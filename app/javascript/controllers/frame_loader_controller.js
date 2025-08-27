import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["frame"]

  connect() {
    // this.element.textContent = "Hello World!"
  }

  load(e) {
    const frame = this.frameTargets.find((ft) => ft.id === e.params.id)

    if (frame !== null) {
      frame.innerHTML = "Loading..."
      frame.src = e.params.path
    }
  }
}
