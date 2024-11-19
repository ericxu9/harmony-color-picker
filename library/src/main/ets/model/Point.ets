/**
 * View coordinate position
 *
 * @author yj
 * @date 2024/11/19
 */
export class Point {
  x: number = 0
  y: number = 0

  constructor(x: number, y: number)

  constructor();

  constructor(x: number = 0, y: number = 0) {
    this.x = x;
    this.y = y;
  }
}