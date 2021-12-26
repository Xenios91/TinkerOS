#![no_std]
#![no_main]
#![feature(lang_items)]

use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    let vga_buffer: *mut u8 = 0xb8000 as *mut u8;

    for (i, &byte) in b"PANICK!".iter().enumerate() {
        unsafe {
            *vga_buffer.offset(i as isize * 2) = byte;
            *vga_buffer.offset(i as isize * 2 + 1) = 0xE;
        }
    }

    loop {}
}

#[no_mangle]
pub extern "C" fn kmain() -> ! {
    let vga_buffer: *mut u8 = 0xb8000 as *mut u8;

    for (i, &byte) in b"TinkerOS".iter().enumerate() {
        unsafe {
            *vga_buffer.offset(i as isize * 2) = byte;
            *vga_buffer.offset(i as isize * 2 + 1) = 0xE;
        }
    }

    loop {}
}
