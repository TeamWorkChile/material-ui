package_file="package.json"
tsconfig_file="tsconfig.json"
vite_file="vite.config.js"
path=$(realpath .)
base_dir=".scripts"
config_dir="$path/$base_dir/config"
temp_dir="$path/$base_dir/temp"
bash_dir="$path/$base_dir/macos/bash"

os_type=$(uname)

if [[ "$os_type" != "Darwin" ]]; then
    echo -e "\033[31mError: This script is only compatible with macOS.\033[0m"
    echo ""
    echo -e "You can use the following npm command to run from \033[34mwindows:\033[0m"
    echo ""
    echo -e "\033[34m> npm run win:create:lib:component:react\033[0m"
    exit
fi

clear

echo -e "\033[37m******************************************************************\033[0m"
echo -e "\033[37m*                                                                *\033[0m"
echo -e "\033[37m*                                                                *\033[0m"
echo -e "\033[37m*      Welcome to the\033[0m \033[34mReact component\033[0m \033[37mcreation assistant\033[0m 🚀      \033[37m*\033[0m"
echo -e "\033[37m*                                                                *\033[0m"
echo -e "\033[37m*                                                                *\033[0m"
echo -e "\033[37m******************************************************************\033[0m"
echo -e "\n"

while true; do
    echo -e '\033[34mName of the React component to create:\033[0m '
    read component

    # Convertir el valor de component a minúsculas
    component_lower=$(echo "$component" | tr '[:upper:]' '[:lower:]')

    # Validar si la variable component tiene información
    if [ -z "$component" ]; then
        echo -e "\033[31mError: No component name provided. Please try again.\033[0m\n"
    elif [ "$component_lower" = ".scripts" ] || [ "$component_lower" = "node_modules" ] || [ "$component_lower" = "." ] || [ "$component_lower" = "clear" ]; then
        echo -e "\033[31mError: Invalid component name. Please choose a different name.\033[0m\n"
    elif find . -type d -name "$component_lower" | grep -q .; then
        clear
        options=("Choose a different name" "Overwrite the existing component" "Cancel creation")
        selected=0
        while true; do
          echo -e "\033[31mA component with the name\033[0m $component \033[31malready exists. Please choose an option:\033[0m\n"
          echo -e "\033[34mWhat would you like to do?\033[0m"
          echo ""
          for i in "${!options[@]}"; do
              if [ $i -eq $selected ]; then
                  echo -e "\033[32m> ${options[$i]}\033[0m"
              else
                  echo "  ${options[$i]}"
              fi
          done
          # Leer la tecla presionada

          read -rsn1 input
          clear
          case $input in
            "B") 
              if [ ! $selected -eq $(echo "${#options[@]} - 1" | bc) ]; then
                selected=$(echo "$selected + 1" | bc)
              else
                selected=0
              fi
              ;;
            "A") 
              if [ ! $selected -eq 0 ]; then
                selected=$(echo "$selected - 1" | bc)
              else
                selected=$(echo "${#options[@]} - 1" | bc)
              fi
              ;;
            '')
              break
              ;;
          esac
        done

        case $selected in
          0) 
            while true; do
              echo -e '\033[34mName of the React component to create:\033[0m '
              read component_new
              component_lower=$(echo "$component_new" | tr '[:upper:]' '[:lower:]')
              component=$component_new
              if [ -z "$component_new" ]; then
                echo -e "\033[31mError: No component name provided. Please try again.\033[0m\n"
              elif [ "$component_lower" = ".scripts" ] || [ "$component_lower" = "node_modules" ] || [ "$component_lower" = "." ] || [ "$component_lower" = "clear" ]; then
                echo -e "\033[31mError: Invalid component name. Please choose a different name.\033[0m\n"
              elif find . -type d -name "$component_lower" | grep -q .; then
                clear
                options=("Choose a different name" "Overwrite the existing component" "Cancel creation")
                selected=0
              else
                break
              fi
            done
            ;;
          1)
            echo -e "\033[33mAre you sure you want to overwrite the component $component_lower?\033[0m (y/n)"
            read confirm
            if [ "$confirm" == "y" ]; then
                rm -rf $component_lower
            else
                echo -e "\033[31mThe creation of the React component has been canceled. Bye.\033[0m\n"
                exit
            fi
            ;;
          2)
            echo -e "\033[31mThe creation of the React component has been canceled. Bye.\033[0m\n"
            exit
            ;;
        esac
        break
    else
        break
    fi
done

component_dir=$path/$component
component_src_dir=$component_dir/src
index_file=$component_src_dir/index.tsx
index_scss_file=$component_src_dir/$component_lower.scss

start_time=$(date +%s%3N)

mkdir -p $component_src_dir

touch $index_file $index_scss_file

# add content template jsx in index.tsx
bash $bash_dir/react.component.jsx.sh $index_file $component 

# add content template styles in file scss 
bash $bash_dir/react.component.sass.sh $index_scss_file $component 

cp -r $config_dir/_$package_file $component_dir/$package_file
cp -r $config_dir/_$tsconfig_file $component_dir/$tsconfig_file
cp -r $config_dir/_$vite_file $component_dir/$vite_file

sed -i '' "s/{{component}}/$component/" $component_dir/$vite_file 

# add script to package.json build production optimized
if ! grep -q "build:$component" $path/$package_file; then
    awk -v component="$component" '
      BEGIN { added = 0 }
      /"scripts": {/ {
        print
        print "    \"build:" component "\": \"cd " component " && npm run build\","
        added = 1
        next
      }
      { print }
      END {
        if (!added) {
          print "  \"scripts\": {"
          print "    \"build:" component "\": \"cd " component " && npm run build\""
          print "  }"
        }
      }
    ' $path/$package_file > $temp_dir/temp_$package_file && mv $temp_dir/temp_$package_file $path/$package_file
fi

clear

echo -e "\n"
echo -e "\033[32m\xE2\x9C\x94 The React component named has been successfully created\033[0m" $component

# Obtener el tamaño del archivo index.tsx
file_size=$(stat -f%z $index_file)
file_sass_size=$(stat -f%z $index_scss_file)
file_package_size=$(stat -f%z $component_dir/$package_file)
file_tsconfig_size=$(stat -f%z $component_dir/$tsconfig_file)
file_vite_size=$(stat -f%z $component_dir/$vite_file)
dir_src_size=$(echo "$file_size + $file_sass_size" | bc)

file_size_kb=$(echo "scale=3; $file_size / 1024" | bc)
file_sass_size_kb=$(echo "scale=3; $file_sass_size / 1024" | bc)
file_package_size_kb=$(echo "scale=3; $file_package_size / 1024" | bc)
file_tsconfig_size_kb=$(echo "scale=3; $file_tsconfig_size / 1024" | bc)
file_vite_size_kb=$(echo "scale=3; $file_vite_size / 1024" | bc)
dir_src_size_kb=$(echo "scale=3; $dir_src_size / 1024" | bc)

dir_src_size_kb_formatted=$( [ $file_size -gt 999 ] && echo "" || echo "0")"$file_size_kb" #$(printf "%.3f" $dir_src_size_kb)
file_size_kb_formatted=$( [ $file_sass_size -gt 999 ] && echo "" || echo "0")"$file_sass_size_kb" #$(printf "%.3f" $file_size_kb)
file_sass_size_kb_formatted=$( [ $file_package_size -gt 999 ] && echo "" || echo "0")"$file_package_size_kb" #$(printf "%.3f" $file_sass_size_kb)
file_package_size_kb_formatted=$( [ $file_tsconfig_size -gt 999 ] && echo "" || echo "0")"$file_tsconfig_size_kb" #$(printf "%.3f" $file_package_size_kb)
file_tsconfig_size_kb_formatted=$( [ $file_vite_size -gt 999 ] && echo "" || echo "0")"$file_vite_size_kb" #$(printf "%.3f" $file_tsconfig_size_kb)
file_vite_size_kb_formatted=$( [ $dir_src_size -gt 999 ] && echo "" || echo "0")"$dir_src_size_kb" #$(printf "%.3f" $file_vite_size_kb)

echo ""
echo -e "4 modules created in component folder \033[32m\033[1m$component\033[0m"
echo -e "\033[36m\033[1m  "$dir_src_size_kb_formatted"kB \033[0m   src/"
echo -e "\033[36m\033[1m  "$file_package_size_kb_formatted"kB \033[0m   \033[35m$package_file\033[0m"
echo -e "\033[36m\033[1m  "$file_tsconfig_size_kb_formatted"kB \033[0m   \033[35m$tsconfig_file\033[0m"
echo -e "\033[36m\033[1m  "$file_vite_size_kb_formatted"kB \033[0m   \033[35m$vite_file\033[0m"
echo -e "2 modules created in component folder \033[32m\033[1m$component/src\033[0m"
echo -e "\033[36m\033[1m  "$file_size_kb_formatted"kB \033[0m   \033[90msrc/\033[0m\033[35mindex.tsx\033[0m"
echo -e "\033[36m\033[1m  "$file_sass_size_kb_formatted"kB \033[0m   \033[90msrc/\033[0m\033[35m$component_lower.scss\033[0m"

end_time=$(date +%s%3N)

execution_time=$(echo "$end_time - $start_time" | bc)

echo -e ""
echo -e "\033[32m\xE2\x9C\x94 Build in "$execution_time"ms\033[0m"

echo -e "\n"
echo "Happy coding! 🚀"
echo -e "\n\n"