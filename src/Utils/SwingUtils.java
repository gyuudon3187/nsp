package Utils;

import java.awt.Image;

import javax.swing.ImageIcon;

public class SwingUtils {
  public static ImageIcon getScaledIcon(int x, int y, String path) {
    Image img = new ImageIcon(path).getImage();
    Image newImg = img.getScaledInstance(x, y, Image.SCALE_SMOOTH);
    return new ImageIcon(newImg);
  }
}
