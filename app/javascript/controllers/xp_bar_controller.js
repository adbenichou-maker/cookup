import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fill"]
  static values = {
    old: Number,
    new: Number
  }

  connect() {
    // Start at old percent
    this.fillTarget.style.width = `${this.oldValue}%`

    // Animate to new percent
    requestAnimationFrame(() => {
      this.fillTarget.style.width = `${this.newValue}%`
    })
  }
}
