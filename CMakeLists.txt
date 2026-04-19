cmake_minimum_required(VERSION 3.16)
project(SmartFileOptimizer VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if (NOT DEFINED Qt6_DIR)
    if (EXISTS "C:/Qt/6.11.0/mingw_64/lib/cmake/Qt6/Qt6Config.cmake")
        set(Qt6_DIR "C:/Qt/6.11.0/mingw_64/lib/cmake/Qt6" CACHE PATH "Qt6 install directory")
    endif()
endif()

set(QT_QML_LINT_FILES OFF CACHE BOOL "Disable Qt QML linting" FORCE)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Quick QuickControls2 Concurrent Charts Qml)

set(SOURCES
    src/main.cpp
    src/filescanner.cpp
    src/fileorganizer.cpp
    src/duplicatedetector.cpp
    src/logger.cpp
    src/settingsmanager.cpp
    src/bridge.cpp
)

set(HEADERS
    src/filescanner.h
    src/fileorganizer.h
    src/duplicatedetector.h
    src/logger.h
    src/settingsmanager.h
    src/bridge.h
)

qt_add_executable(SmartFileOptimizer
    ${SOURCES}
    ${HEADERS}
    resources/resources.qrc
)

target_link_libraries(SmartFileOptimizer PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Concurrent
    Qt6::Charts
    Qt6::Qml
)

target_include_directories(SmartFileOptimizer PRIVATE src)
