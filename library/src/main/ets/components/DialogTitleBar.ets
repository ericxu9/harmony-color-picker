/**
 * Dialog title bar
 *
 * @author yj
 * @date 2024/11/19
 */
@Component
export struct DialogTitleBar {

  @Prop title: string | Resource
  onCloseClick?: () => void

  build() {
    RelativeContainer() {
      Row() {
        Text(this.title)
          .fontWeight(FontWeight.Bold)
          .fontSize(16)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .justifyContent(FlexAlign.Center)
      .alignRules( {
        'center': {'anchor': '__container__', 'align': VerticalAlign.Center },
        'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
      })

      Row() {
        SymbolGlyph($r('sys.symbol.xmark'))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor([$r('sys.color.font_primary')])
          .onClick(() => {
            if (this.onCloseClick != null) {
              this.onCloseClick()
            }
          })
      }
      .justifyContent(FlexAlign.Center)
      .alignRules(
        {
          'right': { 'anchor': '__container__', 'align': HorizontalAlign.End },
          'center': {'anchor': '__container__', 'align': VerticalAlign.Center }
        }
      )
      .margin({right: 10})
    }
    .width('100%')
    .height(40)
  }
}