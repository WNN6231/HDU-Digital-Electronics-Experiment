module BeltAlarm(
	input A,
	input B,
	input C,
	output Alarm
);

	assign Alarm = (B & ~C) | (A & ~B);

endmodule