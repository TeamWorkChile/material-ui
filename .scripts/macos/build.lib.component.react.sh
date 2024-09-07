package_file="package.json"
tsconfig_file="tsconfig.json"
vite_file="vite.config.js"
path=$(realpath .)
base_dir=".scripts"
config_dir="$path/$base_dir/config"
temp_dir="$path/$base_dir/temp"

while true; do
    echo -e '\033[34mName of the React component to create:\033[0m '
    read component

    # Convertir el valor de component a minúsculas
    component_lower=$(echo "$component" | tr '[:upper:]' '[:lower:]')

    # Validar si la variable component tiene información
    if [ -z "$component" ]; then
        echo -e "\033[31mError: No component name provided. Please try again.\033[0m\n"
    elif [ "$component" = ".scripts" ] || [ "$component" = "node_modules" ] || [ "$component" = "." ]; then
        echo -e "\033[31mError: Invalid component name. Please choose a different name.\033[0m\n"
    elif find . -type d -name "$component_lower" | grep -q .; then
        echo -e "\033[31mA component with the name\033[0m $component \033[31malready exists. Please choose an option:\033[0m\n"
        while true; do 
          echo -e "\033[35m1. Choose a different name\033[0m"
          echo -e "\033[35m2. Overwrite the existing component\033[0m"
          echo -e "\033[35m3. Cancel creation\033[0m\n"
          echo -e "\033[34mSelect an option:\033[0m"
          read option
          echo -e ""
          case $option in
          1)
              echo -e '\033[34mName of the React component to create:\033[0m '
              read component_new
              component=$(echo "$component_new" | tr '[:upper:]' '[:lower:]')
              break
              ;;
          2)
              rm -rf $component_lower
              # Eliminar el script build:component del objeto scripts en package.json

              break
              ;;
          3)
              echo -e "\033[31mThe creation of the React component has been canceled. Bye.\033[0m\n"
              exit
              ;;
          *) 
              echo -e "\033[31mError: Invalid option. Please try again.\033[0m\n"
              ;;
          esac
        done
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

component_name_capitalized=$(echo "$component" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# add content template jsx in index.tsx 
echo -e "import React, { ReactElement } from 'react';\n" > $index_file
echo "export const $component_name_capitalized = (): ReactElement => {" >> $index_file
echo "  return <>React component created under the name of $component_name_capitalized</>" >> $index_file
echo "}" >> $index_file

# add content template styles in file scss 
echo "* {" > $index_scss_file
echo "  margin: 0;" >> $index_scss_file
echo "  padding: 0;" >> $index_scss_file
echo "  box-sizing: border-box;" >> $index_scss_file
echo "}" >> $index_scss_file
echo "" >> $index_scss_file
echo "@import url('https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap');" >> $index_scss_file
echo "" >> $index_scss_file
echo "// here you can incorporate all your CSS for the React component named $component" >> $index_scss_file

cp -r $config_dir/_$package_file $component_dir/$package_file
cp -r $config_dir/_$tsconfig_file $component_dir/$tsconfig_file
cp -r $config_dir/_$vite_file $component_dir/$vite_file

sed -i '' "s/{{component}}/$component/" $component_dir/$vite_file 

# add script to package.json build production optimized
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

echo -e "\n"
echo -e "\033[32m\xE2\x9C\x94 The React component named has been successfully created\033[0m" $component

# Obtener el tamaño del archivo index.tsx
file_size=$(stat -f%z $index_file)

file_size_kb=$(echo "scale=2; $file_size / 1024" | bc)
file_size_kb_formatted=$(printf "%.2f" $file_size_kb)

echo -e ""
echo -e "\033[90m./src/\033[0m\033[35mindex.tsx\033[0m    \033[36m\033[1m "$file_size_kb_formatted"kB \033[0m"

end_time=$(date +%s%3N)

execution_time=$(echo "$end_time - $start_time" | bc)

echo -e ""
echo -e "\033[32m\xE2\x9C\x94 Build in "$execution_time"ms\033[0m"