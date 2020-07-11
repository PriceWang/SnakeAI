class NeuralNet{

    int[] layernum;

    float[][] layer;//神经网络各层节点
    float[][] layerErr;//神经网络各节点误差
    float[][][] layer_weight;//各层节点权重
    float[][][] layer_weight_delta;//各层节点权重动量
    float mobp;//动量系数
    float rate;//学习系数
 
    NeuralNet (int[] layernum, float rate, float mobp) {

        this.mobp = mobp;
        this.rate = rate;
        this.layernum = layernum;

        layer = new float[layernum.length][];
        layerErr = new float[layernum.length][];
        layer_weight = new float[layernum.length][][];
        layer_weight_delta = new float[layernum.length][][];

        for(int l = 0; l < layernum.length; l++) {
            layer[l] = new float[layernum[l]];
            layerErr[l] = new float[layernum[l]];
            if (l + 1 < layernum.length) {
                layer_weight[l] = new float[layernum[l] + 1][layernum[l + 1]]; //最后一个单元是bias，所以+1
                layer_weight_delta[l] = new float[layernum[l] + 1][layernum[l + 1]];
                for (int j = 0; j < layernum[l] + 1; j++)
                    for(int i = 0; i < layernum[l + 1]; i++)
                        layer_weight[l][j][i] = random(-5, 5);//随机初始化权重
            }   
        }
    }

    //逐层向前计算输出
    float[] computeOut (float[] in) {
        for (int l = 1; l < layer.length; l++) {
            for (int j = 0; j < layer[l].length; j++) {
                float z = layer_weight[l - 1][layer[l - 1].length][j]; // bias
                for (int i = 0; i < layer[l - 1].length; i++){
                    layer[l - 1][i] = l == 1 ? in[i] : layer[l - 1][i]; // 加入输入层，考虑优化移除三目运算
                    z += layer_weight[l - 1][i][j] * layer[l - 1][i];
                }
                layer[l][j] = 1 / (1 + exp(-z));
            }
        }
        return layer[layer.length - 1];
    }

    //逐层反向计算误差并修改权重
    void updateWeight(float[] tar) {
        int l = layer.length - 1;
        for(int j = 0; j < layerErr[l].length; j++)
            layerErr[l][j] = layer[l][j] * (1 - layer[l][j]) * (tar[j] - layer[l][j]);
 
        while(l-- > 0) {
            for(int j = 0; j < layerErr[l].length; j++) {
                float z = 0.0;
                for(int i = 0; i < layerErr[l + 1].length; i++){
                    z = z + l > 0 ? layerErr[l + 1][i] * layer_weight[l][j][i] : 0;
                    layer_weight_delta[l][j][i] = mobp * layer_weight_delta[l][j][i] + rate * layerErr[l + 1][i] * layer[l][j];//隐含层动量调整
                    layer_weight[l][j][i] += layer_weight_delta[l][j][i];//隐含层权重调整
                    if(j == layerErr[l].length - 1) {
                        layer_weight_delta[l][j + 1][i] = mobp * layer_weight_delta[l][j + 1][i] + rate * layerErr[l + 1][i];//截距动量调整
                        layer_weight[l][j + 1][i] += layer_weight_delta[l][j + 1][i];//截距权重调整
                    }
                }
                layerErr[l][j] = z * layer[l][j] * (1 - layer[l][j]); //记录误差
            }
        }
    }

    NeuralNet clone() {
        NeuralNet clone = new NeuralNet(layernum, rate, mobp);
        for(int l = 0; l < layernum.length; l++) {
            for (int j = 0; j < layernum[l] + 1; j++)
                if (l + 1 < layernum.length) {
                    for(int i = 0; i < layernum[l + 1]; i++)
                        clone.layer_weight[l][j][i] = layer_weight[l][j][i];
                }
        }
        
        return clone;
    }
    
}
