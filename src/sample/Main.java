package sample;

import javafx.animation.Animation;
import javafx.animation.AnimationTimer;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXMLLoader;
import javafx.geometry.Bounds;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.Pane;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Line;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import javafx.util.Duration;

import java.io.File;
import java.security.Key;
import java.util.Random;

import static javafx.scene.paint.Color.*;

public class Main extends Application {

    private Node dino;
    private Node cactus;
    private Cactus cactusObject;
    private Line ground;
    private Group root;
    private Scene scene;

    private boolean isJumping;

    @Override
    public void start(Stage primaryStage) throws Exception {
        Parent root = FXMLLoader.load(getClass().getResource("sample.fxml"));
        primaryStage.setScene(new Scene(root, 1000, 700));

        dino = new ImageView(new Image(new File("C:/Users/jjohn/Documents/PixelArt/Dinosaur.png").toURI().toString()));
        int random = new Random().nextInt(4 + 1);
        cactusObject = new Cactus(new File("C:/Users/jjohn/Documents/PixelArt/cactus" + random + ".png"), random);
        cactus = cactusObject.getIV();

        primaryStage.setTitle("Dino!");

        ground = new Line();
        ground.setStartX(0.0);
        ground.setStartY(450.0);
        ground.setEndX(1000.0);
        ground.setEndY(450.0);

        root = new Group(ground, dino, cactus);
        scene = new Scene(root, 1000, 700);

        dino.setLayoutY(320);
        cactus.setLayoutY(cactusObject.cactus.restingY);
        cactus.setLayoutX(1050);
        primaryStage.setScene(scene);
        primaryStage.show();


        Timeline timeline = new Timeline(new KeyFrame(Duration.millis(20.0),
        new EventHandler<ActionEvent>() {
            double velocity = 0.0;
            double acceleration = .5;
            boolean enactGravity = true;
            boolean keepPlaying = true;
            Text text = new Text();

            @Override
            public void handle(ActionEvent t) {
                if (keepPlaying) {
                    long startTime = System.currentTimeMillis();
                    long currentTime = (System.currentTimeMillis() - startTime) / 10;
                    text.setText("Score: " + currentTime);
                    text.setX(100);
                    text.setY(100);
                    dino.setLayoutY(dino.getLayoutY() + velocity);

                    if (dino.getLayoutY() >= 318) {
                        enactGravity = false;
                        velocity = 0;
                        dino.setLayoutY(318);
                    } else {
                        enactGravity = true;
                    }
                    if (enactGravity) {
                        velocity += acceleration;
                    }
                    scene.setOnKeyPressed(ePress -> {
                        KeyCode keycode = ePress.getCode();
                        if (keycode.equals(keycode.SPACE) && dino.getLayoutY() >= 315) {
                            velocity = -10;
                        }
                    });

                    cactus.setLayoutX(cactus.getLayoutX() - 10);

                    if (cactus.getLayoutX() < -200) {
                        int random = new Random().nextInt(4 + 1);
                        cactus.setLayoutX(1050);
                    }

                    if (dino.getLayoutX() >= cactus.getLayoutX() + cactusObject.cactus.minX && dino.getLayoutX() <= cactus.getLayoutX() + cactusObject.cactus.maxX
                        && (dino.getLayoutY() >= cactus.getLayoutY() + cactusObject.cactus.minY || dino.getLayoutY() <= 310)) {
                        keepPlaying = false;

                    }
                }
            }
        }));
        timeline.setCycleCount(timeline.INDEFINITE);
        timeline.play();

    }


    public static void main(String[] args) {
        launch(args);
    }

}
