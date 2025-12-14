# Đây là repos chỉnh sửa ảnh dựa trên Flutter và Python


## Đọc thêm về Flutter ở đây
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- For help getting started with Flutter development, view the
 [online documentation](https://docs.flutter.dev/), which offers tutorials,
 samples, guidance on mobile development, and a full API reference.


# CLONE AND RUN

--> Có thể clone repos này thông qua
```
git clone: https://github.com/vynt2401/App_Configure
```

--> Sau khi clone repos --> trỏ đến thư mục 
```
Release > project_xla.exe 
```
để chạy được app chính trên Windows

# Ở trong DATA -> RUN SERVER.PY

### Bash Script Enviroment
### Linux 

Kiểm tra Python đã cài đặt chưa

```
#Linux (ubuntu)
python --version
```

```
#Windows
python --version
```

Nếu chưa có, có thể cài đặt thông qua

```
#Linux (ubuntu)
sudo apt-get install python3
```

```
#Windows --> có thể tải tại đây
https://www.python.org/downloads/
```

Sau đó cài đặt Virtual Enviroment 
```
#Linux (ubuntu)
python3 -m pip install virtualenv 
```

Tạo Enviroment và kích hoạt Enviroment Python

```
#Linux (ubuntu)
virtualenv venv_name
source venv_name/bin/activate
```

```
#Windows
python -m venv venv_name
.\venv_name\Scripts\activate
```

Sau khi activate Enviroment --> tải các package cần thiết

```
#Windows
pip install -r .\requirement.txt

#Linux (ubuntu)
python -m pip install requirement.txt
```
