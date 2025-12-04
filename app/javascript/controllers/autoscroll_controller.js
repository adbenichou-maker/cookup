import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages"]

  connect() {
    this.scrollToBottom()
  }

  // When Turbo receives new messages, scroll again
  messagesTargetChanged() {
    this.scrollToBottom()
  }

  scrollToBottom() {
    const el = this.messagesTarget
    el.scrollTop = el.scrollHeight    // Always scroll to latest message
  }
}
