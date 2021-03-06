#!/bin/bash

# Run all datasets with the default parameters
cd ..
source activate graph
# Best parameter in isolated default search
batch_size=32
num_layers=5
lr=0.01
num_mlp_layers=2
hidden_dim=32
final_dropout=0
epochs=20

echo "====SOCIAL-DATASETS===="
for dname in IMDBMULTI REDDITBINARY REDDITMULTI5K
do
    echo Processing $dname...
    for self_rate in $(seq 0.05 0.05 0.95) 
    do
        for fold in 0 1 2 3 4 5 6 7 8 9
        do
            echo Processing $dname at fold $fold ...
            python main.py --dataset $dname \
                           --epochs $epochs \
                           --batch_size $batch_size \
                           --num_layers $num_layers \
                           --lr $lr \
                           --num_mlp_layers $num_mlp_layers \
                           --hidden_dim $hidden_dim \
                           --fold_idx $fold \
                       --filename "$dname"_self_"$self_rate"_result_fold_$fold \
                           --device cpu \
                           --degree_as_tag \
                           --corrupt_label \
                           --T "$self_rate" \
            > ./logs/"$dname"_self_"$self_rate".log
            echo Done.
        done
    done
done

