import java.util.Collections;

class DeepQNet {

    final float GAMMA = 0.9;
    final float INITIAL_EPSILON = 0.5;
    final float FINAL_EPSILON = 0.01;
    final int REPLAY_SIZE = 10000;
    final int BATCH_SIZE = 128;

    ArrayList<ArrayList> experience;

    float epsilon;
    int state_dim;
    int action_dim;
    
    int step = 0;

    NeuralNet targetNet;
    NeuralNet mainNet;

    // 初始化
    DeepQNet (int[] layers) {
        experience = new ArrayList<ArrayList>();
        
        //init some parameters
        epsilon = INITIAL_EPSILON;

        // 8个状态：蛇头方向二进制表示、蛇头到四面墙距离、食物相对位置二进制表示
        state_dim = layers[0];

        // 4个动作：上下左右
        action_dim = layers[layers.length - 1];

        mainNet = new NeuralNet(layers, 0.4, 0.8);
        targetNet = mainNet.clone();
        //create_training_method();

    }

    // 感知存储信息
    void perceive(float[] state, int action, float reward, float[] nextState, boolean done) {

        ArrayList<Object> temp = new ArrayList<Object>();
        temp.add(state);
        temp.add(action);
        temp.add(reward);
        temp.add(nextState);
        temp.add(done);

        experience.add(temp);
        if (experience.size() > REPLAY_SIZE)
            experience.remove(0);
        if (experience.size() > BATCH_SIZE) {
            train_Q_network();
        }
             
    }

    // 训练网络
    void train_Q_network() { //<>//
        step++;

        ArrayList<ArrayList> temp = (ArrayList<ArrayList>)experience.clone();
        Collections.shuffle(temp);

        // 加入minibatch
        ArrayList<ArrayList> minibatch = new ArrayList<ArrayList>(temp.subList(0, BATCH_SIZE));       

        for (int idx = 0; idx < BATCH_SIZE; idx++) {

            float[] state = (float[])minibatch.get(idx).get(0);
            int action = (int)minibatch.get(idx).get(1);
            float reward = (float)minibatch.get(idx).get(2);
            float[] nextState = (float[])minibatch.get(idx).get(3);

            float[] qValue = mainNet.computeOut(state);
            float[] qValueNext = targetNet.computeOut(nextState);
            float y;        

            boolean done = (boolean)minibatch.get(idx).get(4);
            if (done) {
                y = reward;
            } else {
                y = reward + GAMMA * max(qValueNext);
            }

            float[] targetY = new float[action_dim];
            for (int i = 0; i < action_dim; i++) {
                if (i == action) {
                    targetY[i] = y;
                } else {
                    targetY[i] = qValue[i];
                }
            }

            mainNet.updateWeight(targetY);
            
        }
        if (step % 10 == 0)
            targetNet = mainNet.clone();

    }
    

    // 输出带随机的动作
    int egreedy_action(float[] state) {
        float[] qValue = mainNet.computeOut(state);
        if (random(1) <= epsilon){
            if (epsilon > FINAL_EPSILON)
                epsilon -= (INITIAL_EPSILON - FINAL_EPSILON) / 10000;
            return int(floor(random(action_dim)));
        } else{
            if (epsilon > FINAL_EPSILON)
                epsilon -= (INITIAL_EPSILON - FINAL_EPSILON) / 10000;
            int largest = 0;
            for (int i = 1; i < qValue.length; i++) {
                if (qValue[i] > qValue[largest])
                    largest = i;
            }
            return largest;
        }
    }

    // 输出动作
    int action(float[] state) {
        float[] qValue = mainNet.computeOut(state);
        int largest = 0;
        for (int i = 1; i < qValue.length; i++) {
            if (qValue[i] > qValue[largest])
                largest = i;
        }
        return largest;
    }

}
