float menuStart;
float gridWidth;
float panelStartX;
float panelStartY;

PVector panelStart;
PVector panelSize = new PVector(10, 10);

PFont font;
Snake snake;

boolean AI = true;
int AIMode = 0;

DeepQNet DQN;

int fps = 15;

void setup() {
    font = createFont("font.ttf", 32);

    size(1600, 900);
    frameRate(fps);
    //fullScreen();

    menuStart = height / 9 * 11;
    gridWidth = height / (panelSize.y + 2);
    panelStartX = (menuStart - gridWidth * panelSize.x) / 2;
    panelStartY = gridWidth;
    panelStart = new PVector(panelStartX, panelStartY);

    if (AI) {
        DQN = new DeepQNet(new int[]{8, 8, 6, 4, 4});
    }

    snake = new Snake(gridWidth, panelStart, panelSize);
}

void draw() {
    init();

    textFont(font, 32);

    if (snake.reset) {
        snake.initSnake();
    }

    if (AI) {

        float[] state = snake.getState();
        int action = 0;

        text("Training Generation: " + str(snake.gen) + "\nScore: " + str(snake.score), (width + menuStart) / 2, height - 5 * gridWidth / 2);
        text(str(state[0])+' '+str(state[1]) +'\n'+ str(state[2])+' '+str(state[3]) +' '+ str(state[4])+' '+str(state[5]) +'\n'+ str(state[6])+' '+str(state[7]), (width + menuStart) / 2, height / 2);
        action = DQN.egreedy_action(state);
      
        char[] str = {'U', 'L', 'D', 'R'};
        snake.turnAround(str[action]);
        snake.moveStraight();

        float[] next_state = snake.getState();
        float reward = 0;
        if (snake.collision())
            reward = -1;
        if (snake.eat())
            reward = 2;
        DQN.perceive(state, action, reward, next_state, snake.reset);        

    } else {        
        if (!snake.pause) {
            snake.moveStraight();
            text("空格键暂停\n回车键复位", (width + menuStart) / 2, height - 5 * gridWidth / 2);
        } else {
            text("空格键开始/继续\n回车键复位", (width + menuStart) / 2, height - 5 * gridWidth / 2);
        }
    }
    snake.show();

}

void init() {
    background(0);

    stroke(255);

    noFill();
    rect(panelStartX, panelStartY, panelSize.x * gridWidth, panelSize.y * gridWidth);

    line(menuStart, 0, menuStart, height);

    line(menuStart, 5 * gridWidth, width, 5 * gridWidth);

    textFont(font, 64);
    textAlign(CENTER, CENTER);
    text("智能贪吃蛇", (width + menuStart) / 2, 5 * gridWidth / 2);

    line(menuStart, height - 5 * gridWidth, width, height - 5 * gridWidth);
}

void keyPressed() {
    if (key == ' ') {
        snake.pause = !snake.pause;
    }
    if (key == ENTER) {
        snake.reset = true;
    }
    if (key == CODED && snake.pause == false) {
        switch (keyCode) {
            case RIGHT:
                snake.turnAround('R');
                break;
            case LEFT:
                snake.turnAround('L');
                break;
            case UP:
                snake.turnAround('U');
                break;
            case DOWN:
                snake.turnAround('D');
                break;            	
        }
    }
}
