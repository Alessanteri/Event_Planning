import $ from "jquery"
import { Socket } from "phoenix"

let socket = new Socket("/socket", { params: { token: window.userToken } })

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("update_data:lobby", {})


channel.join()
    .receive("ok", resp => {
        console.log("Joined successfully", resp)

    })
    .receive("error", resp => {
        console.log("Unable to join", resp)
    })


//let form = document.querySelector("#event-from")


document.querySelector("#event-from").addEventListener('submit', (e) => {
    e.preventDefault()
    let { value: repetition } = e.target.querySelector('#repetition')
    let { value: date_year } = e.target.querySelector('#start_date_year')
    let { value: date_month } = e.target.querySelector('#start_date_month')
    let { value: date_day } = e.target.querySelector('#start_date_day')
    let { value: date_hour } = e.target.querySelector('#start_date_hour')
    let { value: date_minute } = e.target.querySelector('#start_date_minute')
    channel.push('rerender', { message: { repetition, date_year, date_month, date_day, date_hour, date_minute } })
    //location.reload()
})

channel.on("update_data:lobby:new_message", (message) => {
    console.log("message", message)
    //var newtab = window.open('http://localhost:4000/users/2/my_schedule');
    //location.reload();
    //renderMessage(message)
});


const renderMessage = function (message) {
    console.log("MESSAGE RENDERED", message.content.repetition)
    location.reload()
    let messageTemplate = `
      <li class="list-group-item">${message.content.repetition}</li>
    `
    //document.querySelector("#message").innerHTML += messageTemplate
    //document.querySelector("#ttttt").innerHTML += messageTemplate
};

export default socket