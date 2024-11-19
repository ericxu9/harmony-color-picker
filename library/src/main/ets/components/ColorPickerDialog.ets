import { Size } from '@kit.ArkUI'
import { Point } from '../model/Point'
import ColorUtils from '../utils/ColorUtils'
import { DialogTitleBar } from './DialogTitleBar'

/**
 * Color picker dialog based on HSV color model
 *
 * @author yj
 * @date 2024/11/19
 */
@CustomDialog
export struct ColorPickDialog {

  controller: CustomDialogController
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private hueContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private satValContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  /**
   * hue panel point
   */
  private hueTrackerPointSize: Size = { width: 20, height: 20 }
  @State private hueTrackerPoint: Point =
    new Point(0 - this.hueTrackerPointSize.height * 0.5, 0 - this.hueTrackerPointSize.width * 0.5)
  /**
   * satVal panel point
   */
  private satValTrackerPointSize: Size = { width: 24, height: 24 }
  @State private satValTrackerPoint: Point =
    new Point(0 - this.satValTrackerPointSize.width * 0.5, 0 - this.satValTrackerPointSize.height * 0.5)
  /**
   * 默认颜色
   */
  @Link color: string
  @State private hue: number = 360;
  @State private sat: number = 0;
  @State private val: number = 0;

  aboutToAppear(): void {
    // hex to hsv
    const hsv = ColorUtils.hexToHsv(this.color)
    this.hue = hsv[0]
    this.sat = hsv[1]
    this.val = hsv[2]
  }

  build() {
    Column() {
      DialogTitleBar({
        title: $r('app.string.color_picker'), onCloseClick: () => {
          this.controller.close()
        }
      })

      this.SatValPanel()

      Row({ space: 10 }) {
        this.HuePanel()
        Shape() {
          Circle()
            .width(50)
            .height(50)
            .fill(this.getColor())
        }
      }
      .margin(10)
      .width('90%')

      Stack() {
        TextInput({ text: this.color })
          .fontColor('#1d2129')
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .onEditChange((isEditing) => {
            if (!isEditing) {
              const hsv = ColorUtils.hexToHsv(this.color)
              this.hue = hsv[0]
              this.sat = hsv[1]
              this.val = hsv[2]

              // invalidate canvas
              this.invalidateHuePanel()
              this.invalidateSatValPanel()
            }

          })
          .onChange((value) => {
            this.color = value
          })
      }
      .width(120)
      .height(35)
      .backgroundColor('#e5e6eb')
      .margin({ bottom: 10 })

    }
  }

  @Builder
  private SatValPanel() {

    Stack() {
      Canvas(this.satValContext)
        .width('90%')
        .height(200)
        .margin({ top: 20 })
        .onReady(() => {
          this.drawSatValPanel(true)
        })
        .onTouch((event) => {
          let x = event.touches[0].x
          let y = event.touches[0].y

          if (x >= this.satValContext.width) {
            x = this.satValContext.width
          }
          if (x < 0) {
            x = 0
          }

          if (y >= this.satValContext.height) {
            y = this.satValContext.height
          }
          if (y < 0) {
            y = 0
          }

          this.satValTrackerPoint =
            new Point(x - this.satValTrackerPointSize.width * 0.5, y - this.satValTrackerPointSize.height * 0.5)

          this.color = this.getColor()

          const p = this.pointToSatVal(x, y)
          this.sat = p[0]
          this.val = p[1]

        })

      Shape() {
        Circle()
          .size(this.satValTrackerPointSize)
          .fill(Color.Transparent)
          .borderRadius(this.satValTrackerPointSize.width / 2)
          .border({ color: Color.White, width: 4 })
          .fill(Color.Transparent);
      }
      .margin({ top: 20 })
      .enabled(false)
      .focusOnTouch(false)
      .position({ x: this.satValTrackerPoint.x, y: this.satValTrackerPoint.y })
    }
  }

  private drawSatValPanel(isUpdateTrackerPoint: boolean = false) {
    this.satValContext.clearRect(0, 0, this.satValContext.width, this.satValContext.height)

    this.satValContext.fillStyle = ColorUtils.hsvToHex(this.hue, 1, 1);
    this.satValContext.fillRect(0, 0, this.satValContext.width, this.satValContext.height);

    const whiteGradient = this.satValContext.createLinearGradient(0, 0, this.satValContext.width, 0);
    whiteGradient.addColorStop(0, "#fff");
    whiteGradient.addColorStop(1, "transparent");
    this.satValContext.fillStyle = whiteGradient;
    this.satValContext.fillRect(0, 0, this.satValContext.width, this.satValContext.height);

    const blackGradient = this.satValContext.createLinearGradient(0, 0, 0, this.satValContext.height);
    blackGradient.addColorStop(0, "transparent");
    blackGradient.addColorStop(1, "#000");
    this.satValContext.fillStyle = blackGradient;
    this.satValContext.fillRect(0, 0, this.satValContext.width, this.satValContext.height);

    if (isUpdateTrackerPoint) {
      const p = this.setValToPoint(this.sat, this.val)
      this.satValTrackerPoint =
        new Point(p.x - this.satValTrackerPointSize.width / 2, p.y - this.satValTrackerPointSize.height / 2)
    }

  }

  private invalidateSatValPanel() {
    this.satValContext.clearRect(0, 0, this.satValContext.width, this.satValContext.height)
    this.drawSatValPanel(true)
  }

  private setValToPoint(sat: number, val: number): Point {
    const width = this.satValContext.width
    const height = this.satValContext.height
    const p = new Point()
    p.x = sat * width + 0
    p.y = (1 - val) * height + 0
    return p
  }

  private pointToSatVal(x: number, y: number): [number, number] {
    const width = this.satValContext.width
    const height = this.satValContext.height
    if (x < 0) {
      x = 0
    } else if (x > width) {
      x = width
    } else {
      x = x - 0
    }

    if (y < 0) {
      y = 0
    } else if (y > height) {
      y = height
    } else {
      y = y - 0
    }
    return [1 / width * x, 1 - (1 / height * y)]

  }

  @Builder
  private HuePanel() {
    Stack() {
      Canvas(this.hueContext)
        .width('80%')
        .height(20)
        .onReady(() => {
          this.drawHuePanel()
          this.drawSatValPanel()
        })
        .onTouch((event) => {
          let x = event.touches[0].x
          let y = event.touches[0].y

          let xMaxBoundary = this.hueContext.width
          let xMinBoundary = 0
          if (x > xMaxBoundary) {
            x = xMaxBoundary
          }
          if (x < xMinBoundary) {
            x = xMinBoundary
          }

          this.hueTrackerPoint = new Point(x - this.hueTrackerPointSize.width * 0.5, y)

          this.hue = this.pointToHue(x)
          this.invalidateHuePanel()

          this.color = this.getColor()
        })

      Shape() {
        Circle()
          .size(this.hueTrackerPointSize)
          .fill(Color.Transparent)
          .borderRadius(this.hueTrackerPointSize.width / 2)
          .border({ color: Color.White, width: 4 })
          .fill(Color.Transparent);
      }
      .enabled(false)
      .focusOnTouch(false)
      .position({ x: this.hueTrackerPoint.x, y: 0 })
    }
  }

  private drawHuePanel() {
    const grad = this.hueContext.createLinearGradient(0, 0, this.hueContext.width, this.hueContext.height);
    let hue = new Array<string>(361)
    let count = 0
    for (let i = hue.length - 1; i >= 0; i--, count++) {
      hue[count] = ColorUtils.hsvToHex(i, 1, 1)
      grad.addColorStop(1 - i / 360, hue[count])
    }
    this.hueContext.fillStyle = grad
    this.hueContext.fillRect(0, 0, this.hueContext.width, this.hueContext.height)

    const p = this.hueToPoint(this.hue)
    this.hueTrackerPoint = new Point(p.x - this.hueTrackerPointSize.width / 2, 0)
  }

  private invalidateHuePanel() {
    this.hueContext.clearRect(0, 0, this.hueContext.width, this.hueContext.height)
    this.drawHuePanel()
    this.drawSatValPanel()
  }

  /**
   * Get coordinate points based on hue
   * @param hue
   * @returns
   */
  private hueToPoint(hue: number): Point {
    const width = this.hueContext.width
    const p = new Point()
    p.x = (width - (hue * width / 360) + 0)
    p.y = 0
    return p
  }

  /**
   * Calculate hue value based on x coordinate
   * @param x axis
   * @returns
   */
  private pointToHue(x: number) {
    if (x < 0) {
      x = 0
    } else if (x > this.hueContext.width) {
      x = this.hueContext.width
    } else {
      x = x - 0
    }
    let hue = 360 - (x * 360 / this.hueContext.width)
    if (hue < 0) {
      hue = 0
    } else if (hue > 360) {
      hue = 360
    }
    return hue
  }

  private getColor(): string {
    return ColorUtils.hsvToHex(this.hue, this.sat, this.val)
  }

}