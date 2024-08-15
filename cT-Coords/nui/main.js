
new Vue({
    el: '#app',
    data: {
        isOpen: false,  
        coordsTable: {}
    },
    computed: {},
    methods: {

        setNuiData(data) {
            const coords = data.coords
            this.coordsTable = coords
            this.isOpen = true
        },

        copyCoords(text) {
            const tempInput = Object.assign(document.createElement("textarea"), { value: text, style: "position:fixed" });
            document.body.appendChild(tempInput).select();
            document.execCommand("copy");
            tempInput.remove();
            this.sendNotify('Coords as been copied to clipboard! Coords: ' + text)
        },

        sendNotify(text) {
            this.sendUrl({
                type: 'noti',
                msg: text
            })
        },

        close() {
            this.isOpen = false
            this.sendUrl({
                type: 'close'
            })
        },

        sendUrl(data) {
            fetch('https://cT-Coords/int', {
                method: 'POST',
                body: JSON.stringify(data),
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                }
            })
        }

    },
    mounted() {
        window.addEventListener('message', (event) => {
             if (event.data.type === 'open') {
                this.setNuiData(event.data)
             }
        })
        window.addEventListener('keydown', ({key}) => key === "Escape" && this.close())
    }
  });

