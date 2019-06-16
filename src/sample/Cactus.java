package sample;

import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

import java.io.File;

public class Cactus {
    public enum CactusNumber {
        c0(0),
        c1(1),
        c2(2),
        c3(3),
        c4(4);

        public int restingY;
        public int minX;
        public int maxX;
        public int minY;

        CactusNumber(int number) {
            if (number == 0) {
                restingY = 287;
                minX = 52;
                maxX = 60;
                minY = 20;
            } else if (number == 1) {
                restingY = 282;
                minX = 10;
                maxX = 20;
                minY = 200;
            } else if (number == 2) {
                restingY = 266;
                minX = 15;
                maxX = 20;
                minY = 0;
            } else if (number == 3) {
                restingY = 280;
                minX = 15;
                maxX = 20;
                minY = 90;
            } else if (number == 4) {
                restingY = 280;
                minX = 0;
                maxX = 0;
                minY = 0;
            }
        }

        public static CactusNumber fromNumber(int number) {
            if (number == 0) {
                return c0;
            } else if (number == 1) {
                return c1;
            } else if (number == 2) {
                return c2;
            } else if (number == 3) {
                return c3;
            } else if (number == 4) {
                return c4;
            } else {
                return null;
            }
        }
    }

    public ImageView forCactus;
    public CactusNumber cactus;

    public Cactus(File cactusPicture, int number) {
        forCactus = new ImageView(new Image(cactusPicture.toURI().toString()));
        cactus = CactusNumber.fromNumber(number);
    }

    public ImageView getIV() {
        return forCactus;
    }

}
