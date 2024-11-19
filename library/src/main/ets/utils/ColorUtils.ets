/**
 * Color utils
 *
 * @author yj
 */
class ColorUtils {
  /**
   * hex to rbg
   * @param hex value eg. #FF0000
   * @returns [red, green, blue]
   */
  hexToRgb(hex: string): [number, number, number] {
    const r = parseInt(hex.slice(1, 3), 16);
    const g = parseInt(hex.slice(3, 5), 16);
    const b = parseInt(hex.slice(5, 7), 16);
    return [r, g, b];
  }

  /**
   * hex to hsv
   * @param hex value eg. #FF0000
   * @returns [hue, saturation, value]
   */
  hexToHsv(hex: string): [number, number, number] {
    // Remove the hash sign if present
    hex = hex.replace('#', '');

    // Parse the hex string to decimal
    const r = parseInt(hex.slice(0, 2), 16);
    const g = parseInt(hex.slice(2, 4), 16);
    const b = parseInt(hex.slice(4, 6), 16);

    const max = Math.max(r, g, b);
    const min = Math.min(r, g, b);

    const value = max / 255;

    let saturation = (max !== 0) ? ((max - min) / max) : 0;

    let hue = 0;
    if (saturation === 0) {
      hue = 0;
    } else {
      switch (max) {
        case r:
          hue = ((g - b) / (max - min)) + (g < b ? 6 : 0);
          break;
        case g:
          hue = ((b - r) / (max - min)) + 2;
          break;
        case b:
          hue = ((r - g) / (max - min)) + 4;
          break;
      }
      hue /= 6;
      hue = hue >= 0 ? hue : hue + 1;
    }

    return [hue * 360, saturation, value];
  }

  /**
   * hsv to hex
   * @param h hue
   * @param s saturation
   * @param v value
   * @returns hex value eg. #FF0000
   */
  hsvToHex(h: number, s: number, v: number): string {
    let r: number = 0, g: number = 0, b: number = 0;

    // 将HSV值转换为RGB值
    let i = Math.floor(h / 60);
    let f = h / 60 - i;
    let p = v * (1 - s);
    let q = v * (1 - f * s);
    let t = v * (1 - (1 - f) * s);

    switch (i % 6) {
      case 0:
        r = v;
        g = t;
        b = p;
        break;
      case 1:
        r = q;
        g = v;
        b = p;
        break;
      case 2:
        r = p;
        g = v;
        b = t;
        break;
      case 3:
        r = p;
        g = q;
        b = v;
        break;
      case 4:
        r = t;
        g = p;
        b = v;
        break;
      case 5:
        r = v;
        g = p;
        b = q;
        break;
    }

    r = Math.round(r * 255);
    g = Math.round(g * 255);
    b = Math.round(b * 255);

    return `#${this.toHex(r)}${this.toHex(g)}${this.toHex(b)}`;
  }

  toHex(n: number) {
    let hex = n.toString(16);
    return hex.length === 1 ? '0' + hex : hex;
  }
}

export default new ColorUtils()
