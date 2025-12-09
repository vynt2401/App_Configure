from flask import Flask, request, send_file
import cv2
import numpy as np
import io
from skimage.util import random_noise
from scipy.ndimage import uniform_filter
from rembg import remove


app = Flask(__name__)

############### RGB to Gray ##################################################################
def rgb2gray(rgb):
    # Chuyển sang float để tính toán chính xác
    r, g, b = rgb[:,:,0].astype(float), rgb[:,:,1].astype(float), rgb[:,:,2].astype(float)
    
    # Công thức chuyển đổi
    gray = 0.2989 * r + 0.5870 * g + 0.1140 * b
    
    # Làm tròn và chuyển lại về uint8
    return np.round(gray).astype(np.uint8)
###############################################################################################

############### RGB to binary #################################################################
def custom_rgb2binary(img_rgb, threshold=127):
    # Lấy từng kênh màu
    r = img_rgb[:, :, 0].astype(float)
    g = img_rgb[:, :, 1].astype(float)
    b = img_rgb[:, :, 2].astype(float)
    
    # Công thức: gray = 0.2989 * r + 0.5870 * g + 0.1140 * b
    gray = 0.2989 * r + 0.5870 * g + 0.1140 * b
    
    # B. Gray to Binary (Logic của bạn: if pixel > threshold)
    # Tạo ảnh đen (toàn số 0)
    bin_img = np.zeros_like(gray)
    
    # Gán giá trị 255 (Trắng) cho những điểm > threshold
    bin_img[gray > threshold] = 255 
    
    return bin_img.astype(np.uint8)
##############################################################################################


############### Muoi tieu #################################################################
def apply_noise_skimage(image, mode='s&p', amount=0.05, var=0.01):
    
    if mode == 's&p':
        noisy_float = random_noise(image, mode='s&p', amount=amount)
    elif mode == 'gaussian':
       
        noisy_float = random_noise(image, mode='gaussian', mean=0, var=var)
    else:
        return image

    noisy_uint8 = (noisy_float * 255).astype(np.uint8)
    
    return noisy_uint8
##############################################################################################

@app.route('/convert-grayscale', methods=['POST'])
def convert_grayscale():
    # 1. Kiểm tra xem có file được gửi lên không
    if 'file' not in request.files:
        return "Không tìm thấy file", 400
    file = request.files['file']
    
    # 2. Đọc file thành mảng bytes
    in_memory_file = file.read()
    nparr = np.frombuffer(in_memory_file, np.uint8)
    
    # 3. Decode thành ảnh OpenCV (BGR)
    img_bgr = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    # 4. Chuyển BGR sang RGB (để đúng thứ tự màu cho hàm của bạn)
    img_rgb = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)
    
    # 5. Gọi hàm xử lý của bạn
    img_gray = rgb2gray(img_rgb)
    
    # 6. Encode ảnh kết quả lại thành PNG
    # img_gray đang là mảng 2 chiều, imencode sẽ nén nó lại thành format ảnh
    success, encoded_img = cv2.imencode('.png', img_gray)
    
    if not success:
        return "Lỗi khi xử lý ảnh", 500

    # 7. Trả về ảnh dưới dạng file stream
    return send_file(
        io.BytesIO(encoded_img.tobytes()),
        mimetype='image/png',
        as_attachment=False,
        download_name='converted.png'
    )


@app.route('/convert-binary', methods=['POST'])
def convert_binary():
    if 'file' not in request.files:
        return "Missing file", 400
    
    file = request.files['file']
    in_memory_file = file.read()
    nparr = np.frombuffer(in_memory_file, np.uint8)
    
    # Đọc ảnh vào (OpenCV chỉ dùng để ĐỌC file)
    img_bgr = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    # Chuyển BGR sang RGB thủ công (để không dùng cv2.cvtColor)
    # OpenCV đọc là B-G-R, ta đảo ngược lại thành R-G-B
    img_rgb = img_bgr[..., ::-1] 
    
    # GỌI HÀM XỬ LÝ CỦA BẠN
    img_bin = custom_rgb2binary(img_rgb, threshold=127)
    
    # Encode lại thành PNG để trả về
    success, encoded_img = cv2.imencode('.png', img_bin)
    
    if not success:
        return "Error processing", 500

    return send_file(
        io.BytesIO(encoded_img.tobytes()),
        mimetype='image/png',
        as_attachment=False,
        download_name='binary.png'
    )


@app.route('/noise-skimage', methods=['POST'])
def noise_skimage():
    if 'file' not in request.files: return "Missing file", 400
    
    # Lấy tham số từ Flutter gửi lên (loại nhiễu)
    # Mặc định là s&p nếu không gửi gì
    noise_mode = request.form.get('mode', 's&p') 
    
    file = request.files['file']
    nparr = np.frombuffer(file.read(), np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    # Gọi hàm xử lý
    if noise_mode == 'gaussian':
        res_img = apply_noise_skimage(img, mode='gaussian', var=0.02) # Chỉnh độ nhiễu ở đây
    else:
        res_img = apply_noise_skimage(img, mode='s&p', amount=0.05)   # Chỉnh độ nhiễu ở đây
    
    _, encoded = cv2.imencode('.png', res_img)
    return send_file(io.BytesIO(encoded.tobytes()), mimetype='image/png')


@app.route('/filter-noise', methods=['POST'])
def filter_noise():
    if 'file' not in request.files: return "Missing file", 400
    
    # Lấy tham số
    filter_type = request.form.get('type', 'median') 
    ksize = int(request.form.get('size', 3))
    
    file = request.files['file']
    nparr = np.frombuffer(file.read(), np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    res_img = img
    
    # 1. LỌC TRUNG VỊ (MEDIAN)
    if filter_type == 'median':
        if ksize % 2 == 0: ksize += 1 
        res_img = cv2.medianBlur(img, ksize)
        
    # 2. LỌC GAUSSIAN
    elif filter_type == 'gaussian':
        if ksize % 2 == 0: ksize += 1
        res_img = cv2.GaussianBlur(img, (ksize, ksize), 0)

    # 3. LỌC TRUNG BÌNH (MEAN FILTER) - MỚI THÊM
    elif filter_type == 'mean':
        # Hàm cv2.blur chính là Mean Filter tối ưu
        res_img = cv2.blur(img, (ksize, ksize))

    _, encoded = cv2.imencode('.png', res_img)
    return send_file(io.BytesIO(encoded.tobytes()), mimetype='image/png')


@app.route('/edge-sobel', methods=['POST'])
def edge_sobel():
    if 'file' not in request.files: return "Missing file", 400
    
    file = request.files['file']
    nparr = np.frombuffer(file.read(), np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    # 1. Chuyển sang ảnh xám
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    # 2. Tính đạo hàm Sobel (CỐ ĐỊNH KSIZE = 3)
    # ksize=3 là kích thước chuẩn và phổ biến nhất của Sobel
    grad_x = cv2.Sobel(gray, cv2.CV_64F, 1, 0, ksize=3)
    grad_y = cv2.Sobel(gray, cv2.CV_64F, 0, 1, ksize=3)
    
    # 3. Chuyển về số dương (Absolute)
    abs_grad_x = cv2.convertScaleAbs(grad_x)
    abs_grad_y = cv2.convertScaleAbs(grad_y)
    
    # 4. Tổng hợp: G = 0.5*|Gx| + 0.5*|Gy|
    res_img = cv2.addWeighted(abs_grad_x, 0.5, abs_grad_y, 0.5, 0)

    _, encoded = cv2.imencode('.png', res_img)
    return send_file(io.BytesIO(encoded.tobytes()), mimetype='image/png')

@app.route('/edge-prewitt', methods=['POST'])
def edge_prewitt():
    if 'file' not in request.files: return "Missing file", 400
    
    file = request.files['file']
    nparr = np.frombuffer(file.read(), np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    # 1. Chuyển sang ảnh xám
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    # 2. Định nghĩa Kernel Prewitt
    # Kernel X: Phát hiện cạnh ngang
    kernel_x = np.array([[1, 1, 1],
                         [0, 0, 0],
                         [-1, -1, -1]])
                         
    # Kernel Y: Phát hiện cạnh dọc
    kernel_y = np.array([[-1, 0, 1],
                         [-1, 0, 1],
                         [-1, 0, 1]])
    
    # 3. Áp dụng bộ lọc (filter2D)
    # Dùng CV_64F để giữ giá trị âm
    prewitt_x = cv2.filter2D(gray, cv2.CV_64F, kernel_x)
    prewitt_y = cv2.filter2D(gray, cv2.CV_64F, kernel_y)
    
    # 4. Chuyển về số dương (Absolute)
    abs_grad_x = cv2.convertScaleAbs(prewitt_x)
    abs_grad_y = cv2.convertScaleAbs(prewitt_y)
    
    # 5. Tổng hợp 2 phương: G = 0.5*|Gx| + 0.5*|Gy|
    res_img = cv2.addWeighted(abs_grad_x, 0.5, abs_grad_y, 0.5, 0)

    _, encoded = cv2.imencode('.png', res_img)
    return send_file(io.BytesIO(encoded.tobytes()), mimetype='image/png')


@app.route('/edge-roberts', methods=['POST'])
def edge_roberts():
    if 'file' not in request.files: return "Missing file", 400
    
    file = request.files['file']
    nparr = np.frombuffer(file.read(), np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    # 1. Chuyển sang ảnh xám
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    # 2. Định nghĩa Kernel Roberts (2x2)
    # Kernel X: Dò theo đường chéo chính (+45 độ)
    kernel_x = np.array([[1, 0],
                         [0, -1]])
                         
    # Kernel Y: Dò theo đường chéo phụ (-45 độ)
    kernel_y = np.array([[0, 1],
                         [-1, 0]])
    
    # 3. Áp dụng bộ lọc (filter2D)
    roberts_x = cv2.filter2D(gray, cv2.CV_64F, kernel_x)
    roberts_y = cv2.filter2D(gray, cv2.CV_64F, kernel_y)
    
    # 4. Chuyển về số dương
    abs_grad_x = cv2.convertScaleAbs(roberts_x)
    abs_grad_y = cv2.convertScaleAbs(roberts_y)
    
    # 5. Tổng hợp: G = 0.5*|Gx| + 0.5*|Gy|
    res_img = cv2.addWeighted(abs_grad_x, 0.5, abs_grad_y, 0.5, 0)

    _, encoded = cv2.imencode('.png', res_img)
    return send_file(io.BytesIO(encoded.tobytes()), mimetype='image/png')

# API ENDPOINT: DÒ BIÊN CANNY
@app.route('/edge-canny', methods=['POST'])
def edge_canny():
    if 'file' not in request.files: return "Missing file", 400
    
    # Lấy 2 ngưỡng từ Flutter (mặc định là 100 và 200)
    t1 = int(request.form.get('t1', 100))
    t2 = int(request.form.get('t2', 200))
    
    file = request.files['file']
    nparr = np.frombuffer(file.read(), np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    # 1. Chuyển sang ảnh xám (Canny bắt buộc dùng ảnh xám)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    # 2. Áp dụng Canny
    # Hàm này tự động khử nhiễu Gaussian 5x5 bên trong nó rồi
    edges = cv2.Canny(gray, t1, t2)

    _, encoded = cv2.imencode('.png', edges)
    return send_file(io.BytesIO(encoded.tobytes()), mimetype='image/png')


# API ENDPOINT: XÓA PHÔNG (REMOVE BACKGROUND)
@app.route('/remove-bg', methods=['POST'])
def remove_background():
    if 'file' not in request.files: return "Missing file", 400
    
    file = request.files['file']
    input_data = file.read()
    
    # 1. Gọi hàm xóa phông của thư viện rembg
    # Hàm này nhận bytes và trả về bytes (ảnh PNG trong suốt)
    try:
        output_data = remove(input_data)
    except Exception as e:
        return f"Lỗi xử lý AI: {str(e)}", 500

    # 2. Trả về ảnh trực tiếp (vì rembg đã trả về định dạng ảnh rồi)
    return send_file(
        io.BytesIO(output_data), 
        mimetype='image/png'
    )


# API ENDPOINT: XÓA TIỀN CẢNH (REMOVE FOREGROUND)
@app.route('/remove-foreground', methods=['POST'])
def remove_foreground():
    if 'file' not in request.files: return "Missing file", 400
    
    file = request.files['file']
    # Đọc dữ liệu file vào RAM để dùng cho 2 việc
    in_memory_file = file.read() 
    
    # 1. Đọc ảnh gốc (OpenCV)
    nparr = np.frombuffer(in_memory_file, np.uint8)
    img_orig = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    # 2. Dùng rembg để lấy ảnh tách nền (có kênh Alpha chuẩn)
    # remove() nhận bytes và trả về bytes
    output_bytes = remove(in_memory_file)
    
    # Chuyển bytes kết quả thành ảnh OpenCV (có 4 kênh BGRA)
    img_rembg = cv2.imdecode(np.frombuffer(output_bytes, np.uint8), cv2.IMREAD_UNCHANGED)
    
    # 3. Lấy kênh Alpha (Mặt nạ người) từ kết quả rembg
    # Kênh 3 là Alpha (0: Blue, 1: Green, 2: Red, 3: Alpha)
    alpha_mask = img_rembg[:, :, 3]
    
    # 4. Đảo ngược mặt nạ (Invert)
    # Người đang là Trắng (255) -> Thành Đen (0 - Trong suốt)
    # Nền đang là Đen (0) -> Thành Trắng (255 - Hiển thị)
    mask_inv = cv2.bitwise_not(alpha_mask)
    
    # 5. Ghép mặt nạ đảo ngược vào ảnh gốc
    b, g, r = cv2.split(img_orig)
    
    # Tạo ảnh 4 kênh: B, G, R của ảnh gốc + Alpha đã đảo ngược
    res_img = cv2.merge([b, g, r, mask_inv])

    _, encoded = cv2.imencode('.png', res_img)
    return send_file(io.BytesIO(encoded.tobytes()), mimetype='image/png')


if __name__ == '__main__':
    # Chạy server ở port 8000 để khớp với code Flutter cũ
    app.run(host='0.0.0.0', port=8000, debug=True)
