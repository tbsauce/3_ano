cmake_minimum_required(VERSION 2.8.9)

project(somm22)

if ( CMAKE_COMPILER_IS_GNUCC )
    set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -ggdb -Wall -D_FILE_OFFSET_BITS=64")
endif()

execute_process ( COMMAND dirname ${CMAKE_SOURCE_DIR} 
            OUTPUT_VARIABLE PROJECT_ROOT_DIR
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_ROOT_DIR}/lib)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_ROOT_DIR}/bin)

include_directories(${PROJECT_ROOT_DIR}/include)

add_subdirectory(core)
add_subdirectory(selector)
add_subdirectory(group)

set(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} -L${PROJECT_ROOT_DIR}/lib")

add_executable(somm22
    main.cpp
)

target_link_libraries(somm22
    -static
    "-Wl,--start-group"
    sup
    log
    selector
    binsim  
    binpct  
    binpeq  
    binmem  
    mem
    peq
    pct
    sim  
    "-Wl,--end-group"
)

add_executable(somm22-new
    main-new.cpp
)

target_link_libraries(somm22-new
    -static
    "-Wl,--start-group"
    sup
    log
    selector
    binsim  
    binpct  
    binpeq  
    binmem  
    mem
    peq
    pct
    sim  
    "-Wl,--end-group"
)



set(targets
    main2
)

foreach (target ${targets})
    add_executable(${target} ${target}.cpp)
    target_link_libraries(${target}
        -static
        "-Wl,--start-group"
        sup
        log
        selector
        binsim
        binpct
        binpeq
        binmem
        mem
        peq
        pct
        sim
        "-Wl,--end-group"
    )
endforeach()

