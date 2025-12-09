import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["buttons", "submitBtn"]

  disable() {
    // Add loading class to buttons container
    if (this.hasButtonsTarget) {
      this.buttonsTarget.classList.add("chat-buttons-loading")
    }

    // Disable all submit buttons
    this.submitBtnTargets.forEach(btn => {
      btn.disabled = true
      btn.classList.add("chat-btn-disabled")
    })

    // Also disable any links in the buttons area
    if (this.hasButtonsTarget) {
      const links = this.buttonsTarget.querySelectorAll("a")
      links.forEach(link => {
        link.classList.add("chat-btn-disabled")
        link.style.pointerEvents = "none"
      })
    }
  }
}
