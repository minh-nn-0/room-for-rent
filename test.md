- Trong folder chứa folder game (house) và folder engine (beaver), tạo file CMakeLists.txt với nội dung
```
cmake_minimum_required(VERSION 3.25)

project(Videogames)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(beaver EXCLUDE_FROM_ALL)
add_subdirectory(house EXCLUDE_FROM_ALL)
```
- Sau đó chạy các lệnh
```
mkdir build (nếu không được thì tự tạo folder build)
cmake -S . -B build -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release
(Đợi)
cmake --build build --target rfr
(Đợi)
```

- Sau khi chạy xong file nằm ở 
