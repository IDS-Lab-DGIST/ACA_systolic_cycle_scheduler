i=1
rm -rf /computer_architecture/ACA2/resource
mkdir /computer_architecture/ACA2/resource
while read line || [ -n "$line" ]; do
    printf "\n\n\n"
    printf "start layer_to_matrix.py"
    printf "\n\n"

    model_info=(${line// / })

    echo "model : ${model_info[0]}"
    echo "batch_size : ${model_info[1]}"
    echo "input_shape : ${model_info[2]} (image : [width, height], NLP: [sentence length])"
    python layer_to_matrix.py --model_name ${model_info[0]} --batch_size ${model_info[1]} --input_shape ${model_info[2]}

    ((i+=1))
done < model_list.txt