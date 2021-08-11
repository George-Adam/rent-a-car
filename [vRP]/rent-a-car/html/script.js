$(() => {

    $('body').hide();

    window.addEventListener('message', e => {

        if (e.data.action == 'show') {
            $('body').show();
        
        } else if (e.data.action == 'hide') {
            $('body').hide();
        }

        $('body').keydown(e => {
            if (e.which == 8 || e.which == 27) {
                hasGameFinished = true;
                $.post(`https://rent-a-car/exit`, JSON.stringify({
                    carToSpawn: 'none'
                }));
                $('body').hide();
            }
        })
    })
})
