const buildDataHud = (data) => {

    const {health, shield, hunger, thirst, stamina, stress, radar, voice_mode, voice_active, radio_active} = data;

    if(!radar){
        // $('.interfaz-hud').css({'bottom' : '20vh', 'transition' : '.25s ease-out'});
        $('.interfaz-notifications').css({'bottom' : '23.5vh', 'transition' : '.25s ease-out'});
    }else{
        // $('.interfaz-hud').css({'bottom' : '0', 'transition' : '.25s ease-out'});
        $('.interfaz-notifications').css({'bottom' : '7vh', 'transition' : '.25s ease-out'});
    };

    $(`#health`).css({'height' : `${health}%`})
    $(`#shield`).css({'height' : `${shield}%`})
    $(`#hunger`).css({'height' : `${hunger}%`})
    $(`#thirst`).css({'height' : `${thirst}%`})
    $(`#stamina`).css({'height' : `${100 - stamina}%`})
    $(`#stress`).css({'height' : `${stress}%`})

    if(health > 80){
        $('.health').hide(200)
    }else{
        $('.health').show(200)
    };

    if(shield <= 50){
        $('.shield').hide(200)
    }else{
        $('.shield').show(200)
    };

    if(hunger >= 80){
        $('.hunger').hide(200)
    }else{
        $('.hunger').show(200)
    };

    if(stamina <= 0){
        $('.stamina').hide(200)
    }else{
        $('.stamina').show(200)
    };

    if(thirst >= 80){
        $('.thirst').hide(200)
    }else{
        $('.thirst').show(200)
    };

    if(stress < 5){
        $('.stress').hide(200)
    }else{
        $('.stress').show(200)
    };

    if(voice_mode){
        $('.micro').show(200)

        if(voice_mode == 'Normal'){
            $('#micro').css({'height' : '50%'})
        }else if(voice_mode == 'Whisper'){
            $('#micro').css({'height' : '25%'})
        }else if(voice_mode == 'Shouting'){
            $('#micro').css({'height' : '100%'})
        };
    }else{
        $('.micro').hide()
    };

    if(voice_active){
        $('.micro i').css({'color' : 'var(--active-voice)'})
    }else{
        $('.micro i').css({'color' : 'var(--white-color)'})
    };

    if(radio_active){
        $('.micro i').attr('class', 'fa-duotone fa-walkie-talkie')
        // $('.micro .bar-container').css({'opacity' : '0', 'transition' : '.25s'})
        // $('.radio-channel').fadeIn(200).text(radio_channel + '.0')
    }else{
        $('.micro i').attr('class', 'fa-duotone fa-microphone-lines')  
        // $('.radio-channel').fadeOut(200)
        // $('.micro .bar-container').css({'opacity' : '1',  'transition' : '.25s'})
    }
};