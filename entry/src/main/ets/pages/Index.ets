import { ColorPickDialog } from 'color-picker';

@Entry
@Component
struct Index {
  @State color: string = '#ff0000';

  colorPickDialogController: CustomDialogController | null = new CustomDialogController({
    builder: ColorPickDialog({color: this.color}),
    alignment: DialogAlignment.Center,
    width: '80%',
    cornerRadius: 15,
    backgroundColor: $r('sys.color.background_primary')
  })

  build() {
    Column({space: 10}) {
        Text(this.color)
        Shape() {
          Rect()
            .width(100)
            .height(100)
            .fill(this.color)
        }
        Button('选择颜色')
          .onClick(() => {
            this.colorPickDialogController?.open()
          })
    }
    .height('100%')
    .width('100%')
  }

  aboutToDisappear(): void {
    this.colorPickDialogController = null
  }
}