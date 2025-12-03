import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slider", "label", "input"]

  connect() {
    this.update() // set initial label
  }

  update() {
    const value = parseInt(this.sliderTarget.value)

    const labels = ["Beginner", "Intermediate", "Expert"]
    this.labelTarget.textContent = labels[value]

    // update hidden field for Rails
    this.inputTarget.value = value
  }
}
