index_scss_file=$1
component=$2

component_name_capitalized=$(echo "$component" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

echo "* {" > $index_scss_file
echo "  margin: 0;" >> $index_scss_file
echo "  padding: 0;" >> $index_scss_file
echo "  box-sizing: border-box;" >> $index_scss_file
echo "}" >> $index_scss_file
echo "" >> $index_scss_file
echo "@import url('https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap');" >> $index_scss_file
echo "" >> $index_scss_file
echo "// here you can incorporate all your CSS for the React component named $component_name_capitalized" >> $index_scss_file