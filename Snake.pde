class Snake {

    PImage body = loadImage("body.png");
    PImage up  = loadImage("up.png");
    PImage down = loadImage("down.png");
    PImage left = loadImage("left.png");
    PImage right = loadImage("right.png");

    float gridWidth;
    PVector panelStart;
    PVector panelSize;
    char direction;
    boolean reset;
    boolean pause;
    int score;

    PVector snakeHead;  
    ArrayList<PVector> snakeBody;

    Food food;

    int gen = 0;

    Snake (float gridWidth, PVector panelStart, PVector panelSize) {
        this.gridWidth = gridWidth;
        this.panelStart = panelStart;
        this.panelSize = panelSize;
        reset = true;
        pause = true;
    }

    void initSnake() {
        direction = 'R';
        reset = false;
        pause = true;
        score = 0;

        snakeHead = new PVector(6, 3);
        snakeBody = new ArrayList<PVector>();
        snakeBody.add(new PVector(5, 3));
        snakeBody.add(new PVector(4, 3));

        food = new Food(gridWidth, panelStart, panelSize, snakeHead, snakeBody);
    }

    void moveStraight() {
        float tempX = snakeHead.x;
        float tempY = snakeHead.y;
        switch (direction) {
            case 'R':
                snakeHead.x++;
                break;
            case 'L':
                snakeHead.x--;
                break;
            case 'U':
                snakeHead.y--;
                break;
            case 'D':
                snakeHead.y++;
                break;	
        }
        float tempX2;
        float tempY2;
        for(int i = 0; i < snakeBody.size(); i++) {
            tempX2 = snakeBody.get(i).x;
            tempY2 = snakeBody.get(i).y;
            snakeBody.get(i).x = tempX;
            snakeBody.get(i).y = tempY;
            tempX = tempX2;
            tempY = tempY2;
        } 
        if (eat()) {
            snakeBody.add(new PVector(tempX, tempY));
            food = new Food(gridWidth, panelStart, panelSize, snakeHead, snakeBody);
            score++;
        }
        if (collision()) {
            delay(1000);
            gen++;
            reset = true;
        }
    }

    void turnAround(char dire) {
        if (!((direction == 'U' && dire == 'D') || (direction == 'D' && dire == 'U') || (direction == 'R' && dire == 'L') || (direction == 'L' && dire == 'R'))) {
            direction = dire;
        }
    }

    boolean collision() {
        if (snakeHead.x < 0 || snakeHead.x >= panelSize.x || snakeHead.y < 0 || snakeHead.y >= panelSize.y) {
            return true;
        }
        if (snakeBody.contains(snakeHead)) {
            return true;
        }
        return false;
    }

    boolean eat () {
        return snakeHead.equals(food.pos);
    }

    float[] getState() {
        PVector tempUp = new PVector(snakeHead.x, snakeHead.y - 1);
        PVector tempRight = new PVector(snakeHead.x + 1, snakeHead.y);
        PVector tempDown = new PVector(snakeHead.x, snakeHead.y + 1);
        PVector tempLeft = new PVector(snakeHead.x - 1, snakeHead.y);

        float[] state = new float[12];
        
        state[0] = (tempLeft.x < 0) ? 1 : 0;
        state[1] = (tempUp.y < 0) ? 1 : 0;
        state[2] = (tempRight.x >= panelSize.x) ? 1 : 0;
        state[3] = (tempDown.y >= panelSize.y) ? 1 : 0;

        state[4] = snakeBody.contains(tempUp) ? 1 : 0;
        state[5] = snakeBody.contains(tempRight) ? 1 : 0;
        state[6] = snakeBody.contains(tempDown) ? 1 : 0;
        state[7] = snakeBody.contains(tempLeft) ? 1 : 0;

        state[8] = (tempUp.equals(food.pos)) ? 1 : 0;
        state[9] = (tempRight.equals(food.pos)) ? 1 : 0;
        state[10] = (tempDown.equals(food.pos)) ? 1 : 0;
        state[11] = (tempLeft.equals(food.pos)) ? 1 : 0;
        return state;
    }

    void show() {
        PImage img = new PImage();
        switch (direction) {
            case 'R':
                img = right;
                break;
            case 'L':
                img = left;
                break;
            case 'U':
                img = up;
                break;
            case 'D':
                img = down;
                break;	
        }

        image(img, panelStart.x + snakeHead.x * gridWidth, panelStart.y + snakeHead.y * gridWidth, gridWidth, gridWidth);

        for (int i = 0; i < snakeBody.size(); i++) {
            image(body, panelStart.x + snakeBody.get(i).x * gridWidth, panelStart.y + snakeBody.get(i).y * gridWidth, gridWidth, gridWidth);
        }

        food.show();
    }

}
