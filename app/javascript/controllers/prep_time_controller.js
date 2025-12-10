import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slider", "label", "input"]

  connect() {
    this.update()
  }

  update() {
    const value = parseInt(this.sliderTarget.value)

    if (value === 120) {
      this.labelTarget.textContent = "No limit"
    } else {
      this.labelTarget.textContent = `${value} min`
    }

    this.inputTarget.value = value
  }
}
