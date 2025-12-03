import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  toggle() {
    const panel = this.panelTarget

    // If panel is closed → open it
    if (panel.classList.contains("hidden")) {
      panel.classList.remove("hidden")
      // Let CSS animate height
      panel.style.maxHeight = panel.scrollHeight + "px"
    } else {
      // Animate closing
      panel.style.maxHeight = "0px"
      // After animation ends → hide element
      setTimeout(() => {
        panel.classList.add("hidden")
      }, 300) // matches CSS transition time
    }
  }
}
