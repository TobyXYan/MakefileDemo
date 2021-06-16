###################Simple Make###########################################
#target: dependencies
#	action

#output: main.o message.o
#	g++ main.o message.o -o output
#-o create executable

#main.o: main.cc
#	g++ -c main.cc

#message.o: message.cc message.h
#	g++ -c message.cc
#-c just compile not generate executable
#-c will use x.cc 's name x, and generate x.o

#clean:
#	rm *.o output
###################Simple Make###########################################



#This is an easier to use and modify makefile, but it is slightly more difficult to read than the simple one:
#
# 'make depend' uses makedepend to automatically generate dependencies 
#               (dependencies are added to end of Makefile)
# 'make'        build executable file 'mycc'
# 'make clean'  removes all .o and executable files
#

#1. gcc是GCC中的c编译器
#g++是GCC中的c++编译器
#2. 对于后缀为.c的文件，gcc当成c文件处理，而g++当成c++处理对于后缀为.cpp的文件，两者都当成.cpp文件处理
#3. 在编译阶段，g++会自动链接STL库，而gcc必须要加一个参数-lstdc++
#4. gcc在编译c文件时，可用的预定义宏是比较少的

#cc是Unix的C编译器，全程为c compiler，而gcc为Linux的，全称为GNU compiler collection,是一个编译器集合，既可以编译c也可以编译c++
# define the C compiler to use
CC = gcc
CXX = g++

# define any compile-time flags
CFLAGS = -Wall -g

# define any directories containing header files other than /usr/include
INCLUDES = -I./include

# define library paths in addition to /usr/lib
#   if I wanted to include libraries not in /usr/lib I'd specify
#   their path using -Lpath, something like:
LFLAGS = -L./libs

# define any libraries to link into executable:
#   if I want to link in libraries (libx.so or libx.a) I use the -llibname 
#   option, something like (this will link in libmylib.so and libm.so:
#LIBS = -lmylib -lm
LIBS = 

# define the C source files
SRCS = message.cc main.cc

# define the cc object files 
#
# This uses Suffix Replacement within a macro:
#   $(name:string1=string2)
#         For each word in 'name' replace 'string1' with 'string2'
# Below we are replacing the suffix .c of all words in the macro SRCS
# with the .o suffix
#
OBJS = $(SRCS:.cc=.o)

# define the executable file 
MAIN = mycc

#
# The following part of the makefile is generic; it can be used to 
# build any executable just by changing the definitions above and by
# deleting dependencies appended to the file from 'make depend'
#

.PHONY: depend clean

all:    $(MAIN) copyout
	@echo  Simple compiler named mycc has been compiled

#Here $(MAIN) depends on $(OBJS), if use normal pattern, the following should be 
#$(CXX) -c yy.cc; but here we don't do this one by one, it's implemented by %.o:%.cc
#So we have no souce file to put before -o, but $(OBJS) are reuired to build $(MAIN) along with $(LIBS)
#Hence, $(OBJS) is required to put after -o
$(MAIN): $(OBJS) 
	$(CXX) $(CFLAGS) $(INCLUDES) -o $(MAIN) $(OBJS) $(LFLAGS) $(LIBS)

# this is a suffix replacement rule for building .o's from .cc's
# it uses automatic variables $<: the name of the prerequisite of
# the rule(a .cc file) and $@: the name of the target of the rule (a .o file) 
# (see the gnu make manual section about automatic variables)
#
# $< files that caused the action, here are .cc files
# the name of first prerequisite
# It tells GNU make "here's how to build a .o file from a .c file with the same name
%.o:%.cc
	$(CXX) $(CFLAGS) $(INCLUDES) -c $<  -o $@

clean:
	$(RM) *.o *~ $(MAIN)

depend: $(SRCS)
	makedepend $(INCLUDES) $^

copyout:
	cp include/message.h export/


# DO NOT DELETE THIS LINE -- make depend needs i


#
#	-o：指定生成可执行文件的名称。使用方法为：g++ -o afile file.cpp file.h ... （可执行文件不可与待编译或链接文件同名，否则会生成相应可执行文件且覆盖原编译或链接文件），如果不使用-o选项，则会生成默认可执行文件a.out。
#   -c：只编译不链接，只生成目标文件。
#-g：添加gdb调试选项。

#CC: Program for compiling C programs; default cc
#CXX: Program for compiling C++ programs; default G++
#CFLAGS: Extra flags to give to the C compiler
#CXXFLAGS: Extra flags to give to the C++ compiler
#CPPFLAGS: Extra flags to give to the C preprosessor
#LDFLAGS: Extra flags to give to compilers when they are supposed to invoke the linker
