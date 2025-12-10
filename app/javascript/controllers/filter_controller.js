import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "button"]

  toggle() {
    const panel = this.panelTarget
    const button = this.buttonTarget

    // If panel is closed → open it
    if (panel.classList.contains("hidden")) {
      panel.classList.remove("hidden")
      button.classList.add("active")
      // Let CSS animate height
      panel.style.maxHeight = panel.scrollHeight + "px"
    } else {
      // Animate closing
      panel.style.maxHeight = "0px"
      button.classList.remove("active")
      // After animation ends → hide element
      setTimeout(() => {
        panel.classList.add("hidden")
      }, 300) // matches CSS transition time
    }
  }
}
