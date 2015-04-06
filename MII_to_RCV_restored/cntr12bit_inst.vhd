cntr12bit_inst : cntr12bit PORT MAP (
		aclr	 => aclr_sig,
		clock	 => clock_sig,
		cnt_en	 => cnt_en_sig,
		sclr	 => sclr_sig,
		q	 => q_sig
	);
