$(() => {

    $('body').hide();

    window.addEventListener('message', (event) => {
        const {action, type, data_hud, data_carhud, data_notification, data_street, data_radio, user_radio} = event.data;

        if(action){

            $('body').fadeIn(250);

            if(type == 'show:interfaz:hud'){
                buildDataHud(data_hud)
            };

            // if(type == 'show:interfaz:carhud'){
            //     buildCarHud(data_carhud)
            // };

            // if(type == 'hide:interfaz:carhud'){
            //     $('.container-carhud').removeClass('fadeUp').addClass('fadeDown')

            //     setTimeout(() => {
            //         $('.container-carhud').hide()
            //     }, 300)
            // };

            if(type == 'show:interfaz:notification'){
                appendNotification(data_notification)
            };

            if(type == 'updateStreet'){
                Updatest(data_street)
                // $('.compass > .text').text(data.text);
            };

            if(type == 'showCompass'){
                $('.compass').css({ 'animation': 'fadeInCompass 0.8s ease 0s 1 normal forwards' }).fadeIn(250);
                setTimeout(function(){
                    $('.compass').css({ 'animation': 'none' });
                }, 800);
            };

            if(type == 'hideCompass'){
                $('.compass').css({ 'animation': 'fadeOutCompass 0.8s ease 0s 1 normal forwards' }).fadeOut(250);
                setTimeout(function(){
                    $('.compass').css({ 'animation': 'none' });
                }, 800);
            };

        }else{
            $('body').fadeOut(250);
        };
    })
})