#!/bin/bash
# lambda:GetFunction,ListFunctions
rm -rf download-lambdafn-report.log
for region in us-east-1 us-west-2
do
        for lambdafn in $(aws lambda list-functions --query 'Functions[*].[FunctionName]' --region $region --output text)
        do
                echo "$lambdafn" | tee -a download-lambdafn-report.log
                mkdir -p $PWD/lambda_functions/$region/$lambdafn/
                aws lambda get-function --function-name $lambdafn --region $region --query 'Code.Location' | xargs wget -O $PWD/lambda_functions/$region/$lambdafn/$lambdafn.zip
                unzip -d $PWD/lambda_functions/$region/$lambdafn/ $PWD/lambda_functions/$region/$lambdafn/$lambdafn.zip
        done
done
