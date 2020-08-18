# For when I decide to play with which version of clang / gcc to use.
# Choices are (or will be),
# * "system"  -- Use the installed XCode clang
# * "clang"   -- Use a home-grown Clang
# * "gcc"     -- Use a home-grown GCC 
COMPILER___="system"
VERSION___=""

# if [ "$COMPILER___" = "gcc" ]; then
#   if [ "$VERSION___" = "5.3.0" ]; then
#     # ln -s /usr/local/Cellar/gcc/5.3.0/bin/c++-5 /usr/local/bin/gcc/5.3.0/c++
#     # ln -s /usr/local/Cellar/gcc/5.3.0/bin/cpp-5 /usr/local/bin/gcc/5.3.0/cpp
#     # ln -s /usr/local/Cellar/gcc/5.3.0/bin/g++-5 /usr/local/bin/gcc/5.3.0/g++
#     # ln -s /usr/local/Cellar/gcc/5.3.0/bin/gcc-5 /usr/local/bin/gcc/5.3.0/gcc
#     # ln -s /usr/local/Cellar/gcc/5.3.0/bin/gcov-5 /usr/local/bin/gcc/5.3.0/gcov
#     export PATH="/usr/local/bin/gcc/5.3.0:${PATH}"
#   fi
#   if [ "$VERSION___" = "4.8.4" ]; then
#     # ln -s /usr/local/Cellar/gcc48/4.8.4/bin/c++-4.8 /usr/local/bin/gcc/4.8.4/c++
#     # ln -s /usr/local/Cellar/gcc48/4.8.4/bin/cpp-4.8 /usr/local/bin/gcc/4.8.4/cpp
#     # ln -s /usr/local/Cellar/gcc48/4.8.4/bin/g++-4.8 /usr/local/bin/gcc/4.8.4/g++
#     # ln -s /usr/local/Cellar/gcc48/4.8.4/bin/gcc-4.8 /usr/local/bin/gcc/4.8.4/gcc
#     # ln -s /usr/local/Cellar/gcc48/4.8.4/bin/gcov-4.8 /usr/local/bin/gcc/4.8.4/gcov
#     export PATH="/usr/local/bin/gcc/4.8.4:${PATH}"
#   fi
# fi
