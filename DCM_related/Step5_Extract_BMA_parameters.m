clearvars;
BMS = load('GCD_output_new/BMS_model_inference.mat');
outName = 'GCD_output_new/BMA_parameter.csv';
ind=1;
Bmat = ones(1,31);
for condition=2:3
    for row=1:4
        for col=1:4
            for sub=1:31
                b(sub) = BMS.BMS.DCM.ffx.bma.sEps{1,sub}.B(row,col,condition);
                ind=ind+1;
            end
            Bmat = [Bmat; b];
        end
    end
end
Bmat(1,:) = []; % delect the first row of B mat

ind=1;
Amat = ones(1,31);
for row=1:4
    for col=1:4
        for sub=1:31
            a(sub) = BMS.BMS.DCM.ffx.bma.sEps{1,sub}.A(row,col);
            ind=ind+1;
        end
        Amat = [Amat; a];
    end
end
Amat(1,:) = []; % delect the first row

outMat = [Amat;Bmat];
csvwrite(outName,outMat');