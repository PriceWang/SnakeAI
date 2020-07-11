class Replay {
	
	float[] state;
	int action; 
	float reward;
	float[] nextState;
	boolean done;
	
	// Initialize Replay memory
	Replay (float[] state, int action, float reward, float[] nextState, boolean done) {
		this.state = state.clone();
		this.action = action;
		this.reward = reward;
		this.nextState = nextState;
		this.done = done;
	}
	
}
