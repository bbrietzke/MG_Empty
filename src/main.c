
#include "mgos.h"

enum mgos_app_init_result mgos_app_init(void) {
    int led1 = mgos_sys_config_get_board_led1_pin();

    if(led1 > 0) {
        if(mgos_gpio_setup_output(led1, true)) {
            mgos_gpio_blink(led1, 950, 50);
        }
    }

    return MGOS_APP_INIT_SUCCESS;
}