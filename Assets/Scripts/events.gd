extends Node

# USE THIS FILE TO CREATE SINGALS WHICH OTHER SCENES CAN PICK UP ON.
# TO CONTROL THINGS LIKE UI INCREASES ETC. (CASH INCREASED BY 1? 
# EXAMPLE: EMIT A SIGNAL TO LET ANY SUBSYSTEM WHICH CARES ABOUT CASH KNOW ABOUT THE INCREASE
# IN THIS SCRIPT: signal cash_amount_chaged(cash_value)
# IN CALLER SCRIPT (COIN?): EVENTS.cash_amount_changed.emit(cash_value)
# CONNECT TO THE SIGNAL IN READY FUNCTION TO CATCH THE EVENT: EVENTS.cash_amount_changed.connect(_on_cash_amount_changed)
# ADD THE CONNECTED FUNCTION TO THE CATCHER, func _on_cash_amount_changed(cash_value: int) -> void

@warning_ignore("unused_signal")
signal boost_activated(boost_timer : float)

@warning_ignore("unused_signal")
signal shield_activated(shield_timer : float)

@warning_ignore("unused_signal")
signal trigger_path_calc()

