document.addEventListener('turbolinks:load', function() {
 const timerText = document.querySelector('.test-passage-timer')
 if (timerText) {
   let endTimeToMs = timerText.dataset.endTimeToMs
   let timerId = setInterval(function() {
    let currentTimerValue = Math.ceil((new Date(Number(endTimeToMs)) - new Date())/1000)
    if (currentTimerValue <= 0) {
      timerText.textContent = "0:00"
      document.forms["test-passage-form"].submit()
      clearInterval(timerId)
    } else {
      timerText.textContent = Math.floor(currentTimerValue/60) + ":" + currentTimerValue % 60
    }
   }, 1000);
 }
})
