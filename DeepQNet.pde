import java.util.Collections;

class DeepQNet {

    final float GAMMA = 0.9;
    final float INITIAL_EPSILON = 0.5;
    final float FINAL_EPSILON = 0.01;
    final int REPLAY_SIZE = 10000;
    final int BATCH_SIZE = 128;

    ArrayList<Replay> experience;

    float epsilon;
    int state_dim;
    int action_dim;
    
    int step = 0;

    NeuralNet targetNet;
    NeuralNet mainNet;

    // 初始化
    DeepQNet (int[] layers) {
        experience = new ArrayList<Replay>();
        
        //init some parameters
        epsilon = INITIAL_EPSILON;

        state_dim = layers[0];

        action_dim = layers[layers.length - 1];

        mainNet = new NeuralNet(layers, 0.4, 0.8);
        targetNet = mainNet.clone();

    }

    // 感知存储信息
    void perceive(float[] state, int action, float reward, float[] nextState, boolean done) {

        Replay replay = new Replay(state, action, reward, nextState, done);

        experience.add(replay);
        if (experience.size() > REPLAY_SIZE)
            experience.remove(0);
        if (experience.size() > BATCH_SIZE) {
            train_Q_network();
        }
             
    }

    // 训练网络
    void train_Q_network() {
        step++;

        ArrayList<Replay> temp = new ArrayList<Replay>(experience);
        Collections.shuffle(temp);

        // 加入minibatch
        ArrayList<Replay> minibatch = new ArrayList<Replay>(temp.subList(0, BATCH_SIZE));       

        for (int idx = 0; idx < BATCH_SIZE; idx++) {

            float[] state = minibatch.get(idx).state.clone();
            int action = minibatch.get(idx).action;
            float reward = minibatch.get(idx).reward;
            float[] nextState = minibatch.get(idx).nextState.clone();

            float[] qValue = mainNet.computeOut(state);
            float[] qValueNext = targetNet.computeOut(nextState);
            float y;        

            boolean done = minibatch.get(idx).done;
            if (done) {
                y = reward;
            } else {
                y = reward + GAMMA * max(qValueNext);
            }

            float[] targetY = qValue.clone();
            
            targetY[action] = y;

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
                epsilon -= (INITIAL_EPSILON - FINAL_EPSILON) / 100000;
            return int(floor(random(action_dim)));
        } else{
            if (epsilon > FINAL_EPSILON)
                epsilon -= (INITIAL_EPSILON - FINAL_EPSILON) / 100000;
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
