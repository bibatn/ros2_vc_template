#!/bin/bash
# Module structure's creator. Syntax: generate_module.sh <module_name> [module_format]

if [ $# -eq 0 ]; then
  echo "Syntax: generate_module.sh module_name"
  exit 1
fi

#Module name must be defined!

#Дисковые имена - с подчёркиванием, как_в_параметре
#Имена классов - CaseSensitive

# to_lower
module_name=$1
declare -l module_name
module_name=$module_name

echo $module_name
if [[ ! "$module_name" == [a-z]* ]]; then
  echo "Wrong module name!"
  exit 5
fi


echo "module_name: $module_name"

# ToCamelStyle
ModuleName=${module_name//'_'/' '}
ModuleName=($ModuleName)
ModuleName="${ModuleName[@]^}"
ModuleName=${ModuleName//' '/}

#Module is 'so'
module_format="so"

template_dir=$(pwd)

cd ../dev_ws/src/   #/Modules   #ПЕРЕДЕЛАТЬ!

#Create main Module dir

if [ -d $module_name ]; then   #КАТАЛОГ С ИМЕНЕМ [module_name] УЖЕ СУЩЕСТВУЕТ!
  echo "Directory [$module_name] already exists! Remove it manually!"
  exit 3
else
  mkdir $module_name
  if [ ! -d $module_name ]; then
    echo "Can't create directory $module_name!"
    exit 4
  fi
fi

echo "$module_name\ module directory has been created!"

cd "$module_name"
module_dir=$(pwd)

# Name templates
search_pattern="\[name\]"
Search_pattern="\[Name\]"
SEARCH_PATTERN="\[NAME\]"
new_pattern=$module_name
NewPattern=${ModuleName}
NEWPATTERN=${new_pattern^^}
template_date="\[create_date\]"
current_date="$(date +'%d.%m.%Y')"


######### Create <include> dir
curr_dir=include
if [ ! -d "$curr_dir" ]; then
  mkdir "$curr_dir"
  if [ ! -d "$curr_dir" ]; then
    echo "Can't create directory $curr_dir!"
    exit 6
  fi
  echo "/$curr_dir created!"
else
  echo "/$curr_dir already exists!"
fi

cd "$curr_dir"

curr_dir=$module_name
if [ ! -d "$curr_dir" ]; then
  mkdir "$curr_dir"
  if [ ! -d "$curr_dir" ]; then
    echo "Can't create directory $curr_dir!"
    exit 6
  fi
  echo "/$curr_dir created!"
else
  echo "/$curr_dir already exists!"
fi

## Create header files
cd "$curr_dir"

input_header="$template_dir/include/name/name.h"
output_header="$(pwd)/${module_name}_wrapper.h"

sed -e s/$template_date/$current_date/g \
    -e s/$search_pattern/$new_pattern/g \
    -e s/$Search_pattern/$NewPattern/g \
    -e s/$SEARCH_PATTERN/$NEWPATTERN/g \
     <$input_header >$output_header

if [ ! -f "$output_header" ]; then
  echo  "$output_header file hasn't been created!"
  exit 4
fi
echo  "$output_header file has been created!"


input_header="$template_dir/include/name/ros_name.h"
output_header="$(pwd)/ros_${module_name}.h"

sed -e s/$search_pattern/$new_pattern/g \
    -e s/$Search_pattern/$NewPattern/g \
    -e s/$SEARCH_PATTERN/$NEWPATTERN/g \
     <$input_header >$output_header

if [ ! -f "$output_header" ]; then
  echo  "$output_header file hasn't been created!"
  exit 4
fi
echo  "$output_header file has been created!"

#ПОКА ПРАВИЛЬНО не забудь правильно подняться наверх
cd ..   #up to Module dir
cd ..

######### Create <src> dir
curr_dir=src
if [ ! -d "$curr_dir" ]; then
  mkdir "$curr_dir"
  if [ ! -d "$curr_dir" ]; then
    echo "Can't create directory $curr_dir!"
    exit 6
  fi
  echo "/$curr_dir created!"
else
  echo "/$curr_dir already exists!"
fi

## Create source file
cd "$curr_dir"

input_cpp="$template_dir/src/name.cpp"
output_cpp="$(pwd)/${module_name}_wrapper.cpp"

sed -e s/$template_date/$current_date/g \
    -e s/$search_pattern/$new_pattern/g \
    -e s/$Search_pattern/$NewPattern/g \
    -e s/$search_pattern/$new_pattern/g \
     <$input_cpp >$output_cpp

if [ ! -f "$output_cpp" ]; then
  echo  "$output_cpp file hasn't been created!"
  exit 4
fi
echo  "$output_cpp file has been created!"

input_cpp="$template_dir/src/ros_name.cpp"
output_cpp="$(pwd)/ros_${module_name}.cpp"

sed -e s/$search_pattern/$new_pattern/g \
    -e s/$Search_pattern/$NewPattern/g \
    -e s/$search_pattern/$new_pattern/g \
     <$input_cpp >$output_cpp

if [ ! -f "$output_cpp" ]; then
  echo  "$output_cpp file hasn't been created!"
  exit 4
fi
echo  "$output_cpp file has been created!"

input_cpp="$template_dir/src/name_node.cpp"
output_cpp="$(pwd)/${module_name}_node.cpp"

sed -e s/$search_pattern/$new_pattern/g \
    -e s/$Search_pattern/$NewPattern/g \
    -e s/$search_pattern/$new_pattern/g \
     <$input_cpp >$output_cpp

if [ ! -f "$output_cpp" ]; then
  echo  "$output_cpp file hasn't been created!"
  exit 4
fi
echo  "$output_cpp file has been created!"

cd ..   #up to Module dir

######### Create launch direrctory
curr_dir=launch
if [ ! -d "$curr_dir" ]; then
  mkdir "$curr_dir"
  if [ ! -d "$curr_dir" ]; then
    echo "Can't create directory $curr_dir!"
    exit 6
  fi
  echo "/$curr_dir created!"
else
  echo "/$curr_dir already exists!"
fi

cd "$curr_dir"
input_cpp="$template_dir/launch/name_component.launch.py"
output_cpp="$(pwd)/${module_name}_component.launch.py"

sed -e s/$search_pattern/$new_pattern/g \
    -e s/$Search_pattern/$NewPattern/g \
    -e s/$search_pattern/$new_pattern/g \
     <$input_cpp >$output_cpp

if [ ! -f "$output_cpp" ]; then
  echo  "$output_cpp file hasn't been created!"
  exit 4
fi
echo  "$output_cpp file has been created!"

input_cpp="$template_dir/launch/name_node.launch.py"
output_cpp="$(pwd)/${module_name}_node.launch.py"

sed -e s/$search_pattern/$new_pattern/g \
    -e s/$Search_pattern/$NewPattern/g \
    -e s/$search_pattern/$new_pattern/g \
     <$input_cpp >$output_cpp

if [ ! -f "$output_cpp" ]; then
  echo  "$output_cpp file hasn't been created!"
  exit 4
fi
echo  "$output_cpp file has been created!"

#Create CMake file
input_cm="$template_dir/CMakeLists.txt"
output_cm="$module_dir/CMakeLists.txt"

sed -e s/$search_pattern/$new_pattern/g \
    -e s/$Search_pattern/$NewPattern/g \
    -e s/$SEARCH_PATTERN/$NEWPATTERN/g \
    <$input_cm >$output_cm
    
if [ ! -f "$output_cm" ]; then
  echo  "$output_cm file hasn't been created!"
  exit 4
fi
echo  "$output_cm file has been created!"

input_pxml="$template_dir/package.xml"
output_pxml="$module_dir/package.xml"

sed -e s/$search_pattern/$new_pattern/g \
    <$input_pxml >$output_pxml

if [ ! -f "$output_pxml" ]; then
  echo  "$output_pxml file hasn't been created!"
  exit 4
fi
echo  "$output_pxml file has been created!"

#Подумать что можно еще сделать в этой жизни
if [ -f "$template_dir/name.user" ]; then
  cp "$template_dir/name.user" "$module_dir/$module_name.user"
fi

echo "Done!"

exit 0

