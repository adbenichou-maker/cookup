import { Controller } from "@hotwired/stimulus"

// data-controller="xp-bar"
export default class extends Controller {
  static targets = ["fill"]
  static values = {
    old: Number,
    new: Number
  }

  connect() {
    // Start at old XP
    this.fillTarget.style.width = `${this.oldValue}%`

    // After short delay → animate to new XP
    setTimeout(() => {
      this.fillTarget.style.width = `${this.newValue}%`
    }, 200)
  }
}
