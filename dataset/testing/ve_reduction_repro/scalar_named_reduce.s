	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.file	"ofa_module"
	.text
	.globl	kernel                          # -- Begin function kernel
	.p2align	1
	.type	kernel,@function
kernel:                                 # @kernel
	.cfi_startproc
# %bb.0:
	addi	sp, sp, -160
	.cfi_def_cfa_offset 160
	sd	ra, 152(sp)                     # 8-byte Folded Spill
	sd	s0, 144(sp)                     # 8-byte Folded Spill
	sd	s1, 136(sp)                     # 8-byte Folded Spill
	.cfi_offset ra, -8
	.cfi_offset s0, -16
	.cfi_offset s1, -24
	ld	t0, 224(sp)
	ld	t1, 216(sp)
	ld	t2, 208(sp)
	ld	t3, 200(sp)
	ld	t4, 192(sp)
	ld	t5, 160(sp)
	ld	t6, 168(sp)
	ld	s0, 176(sp)
	ld	s1, 184(sp)
	sd	a2, 96(sp)
	sd	a3, 104(sp)
	sd	a4, 112(sp)
	sd	a5, 120(sp)
	sd	a7, 0(sp)
	sd	t5, 8(sp)
	sd	t6, 16(sp)
	sd	s0, 24(sp)
	sd	s1, 32(sp)
	sd	t4, 40(sp)
	sd	t3, 48(sp)
	sd	t2, 56(sp)
	sd	t1, 64(sp)
	sd	t0, 72(sp)
	sd	a0, 80(sp)
	sd	a1, 88(sp)
	sd	a6, 128(sp)
	lui	a2, %hi(__dispatch_thread_entry_kernel_dispatch_worker_0_0)
	addi	a2, a2, %lo(__dispatch_thread_entry_kernel_dispatch_worker_0_0)
	mv	a3, sp
	li	a0, 0
	li	a1, 0
	call	ofa_dispatch_thread_create
	call	ofa_dispatch_thread_join
	ld	ra, 152(sp)                     # 8-byte Folded Reload
	ld	s0, 144(sp)                     # 8-byte Folded Reload
	ld	s1, 136(sp)                     # 8-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	.cfi_restore s1
	addi	sp, sp, 160
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end0:
	.size	kernel, .Lfunc_end0-kernel
	.cfi_endproc
                                        # -- End function
	.globl	kernel_dispatch_worker_0_0      # -- Begin function kernel_dispatch_worker_0_0
	.p2align	1
	.type	kernel_dispatch_worker_0_0,@function
kernel_dispatch_worker_0_0:             # @kernel_dispatch_worker_0_0
	.cfi_startproc
# %bb.0:
	addi	sp, sp, -176
	.cfi_def_cfa_offset 176
	sd	ra, 168(sp)                     # 8-byte Folded Spill
	sd	s0, 160(sp)                     # 8-byte Folded Spill
	sd	s1, 152(sp)                     # 8-byte Folded Spill
	sd	s2, 144(sp)                     # 8-byte Folded Spill
	sd	s3, 136(sp)                     # 8-byte Folded Spill
	sd	s4, 128(sp)                     # 8-byte Folded Spill
	sd	s5, 120(sp)                     # 8-byte Folded Spill
	.cfi_offset ra, -8
	.cfi_offset s0, -16
	.cfi_offset s1, -24
	.cfi_offset s2, -32
	.cfi_offset s3, -40
	.cfi_offset s4, -48
	.cfi_offset s5, -56
	mv	s3, a6
	mv	s0, sp
	ld	s1, 240(sp)
	ld	s2, 232(sp)
	ld	s4, 208(sp)
	ld	s5, 200(sp)
	ld	a6, 176(sp)
	ld	t0, 184(sp)
	sd	a0, 80(sp)
	sd	a1, 88(sp)
	sd	a2, 96(sp)
	sd	a3, 104(sp)
	sd	a4, 112(sp)
	li	a0, 1
	addi	a1, sp, 80
	addi	a2, sp, 40
	sd	a0, 24(sp)
	sd	a1, 32(sp)
	sd	t0, 72(sp)
	sd	a5, 40(sp)
	sd	s3, 48(sp)
	sd	a7, 56(sp)
	sd	a6, 64(sp)
	sd	a0, 8(sp)
	sd	a2, 16(sp)
	li	a0, 4
	addi	a1, sp, 24
	addi	a2, sp, 8
	call	memrefCopy
	mv	sp, s0
	li	a0, 0
	li	a6, 255
	slli	a2, s4, 2
	add	a2, a2, s5
	li	a3, 511
	j	.LBB1_2
.LBB1_1:                                #   in Loop: Header=BB1_2 Depth=1
	addi	a0, a0, 1
.LBB1_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_4 Depth 2
	blt	a6, a0, .LBB1_5
# %bb.3:                                # %.preheader
                                        #   in Loop: Header=BB1_2 Depth=1
	li	a4, 0
	mul	a5, a0, s2
	slli	s0, a0, 2
	add	s0, s0, s3
	bltz	a3, .LBB1_1
.LBB1_4:                                #   Parent Loop BB1_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	a1, a4, s1
	flw	fa5, 0(s0)
	add	a1, a1, a5
	slli	a1, a1, 2
	add	a1, a1, a2
	flw	fa4, 0(a1)
	fadd.s	fa5, fa4, fa5
	fsw	fa5, 0(s0)
	addi	a4, a4, 1
	bge	a3, a4, .LBB1_4
	j	.LBB1_1
.LBB1_5:
	ld	ra, 168(sp)                     # 8-byte Folded Reload
	ld	s0, 160(sp)                     # 8-byte Folded Reload
	ld	s1, 152(sp)                     # 8-byte Folded Reload
	ld	s2, 144(sp)                     # 8-byte Folded Reload
	ld	s3, 136(sp)                     # 8-byte Folded Reload
	ld	s4, 128(sp)                     # 8-byte Folded Reload
	ld	s5, 120(sp)                     # 8-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	.cfi_restore s1
	.cfi_restore s2
	.cfi_restore s3
	.cfi_restore s4
	.cfi_restore s5
	addi	sp, sp, 176
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end1:
	.size	kernel_dispatch_worker_0_0, .Lfunc_end1-kernel_dispatch_worker_0_0
	.cfi_endproc
                                        # -- End function
	.globl	__dispatch_thread_entry_kernel_dispatch_worker_0_0 # -- Begin function __dispatch_thread_entry_kernel_dispatch_worker_0_0
	.p2align	1
	.type	__dispatch_thread_entry_kernel_dispatch_worker_0_0,@function
__dispatch_thread_entry_kernel_dispatch_worker_0_0: # @__dispatch_thread_entry_kernel_dispatch_worker_0_0
	.cfi_startproc
# %bb.0:
	addi	sp, sp, -96
	.cfi_def_cfa_offset 96
	sd	ra, 88(sp)                      # 8-byte Folded Spill
	sd	s0, 80(sp)                      # 8-byte Folded Spill
	sd	s1, 72(sp)                      # 8-byte Folded Spill
	.cfi_offset ra, -8
	.cfi_offset s0, -16
	.cfi_offset s1, -24
	ld	t0, 0(a0)
	ld	a1, 8(a0)
	ld	a2, 16(a0)
	ld	a3, 24(a0)
	ld	a4, 32(a0)
	ld	a5, 40(a0)
	ld	a6, 48(a0)
	ld	a7, 56(a0)
	ld	t1, 64(a0)
	ld	t2, 72(a0)
	ld	t3, 80(a0)
	ld	t4, 88(a0)
	ld	t5, 96(a0)
	ld	t6, 104(a0)
	ld	s0, 112(a0)
	ld	s1, 120(a0)
	ld	a0, 128(a0)
	sd	a0, 64(sp)
	sd	t5, 32(sp)
	sd	t6, 40(sp)
	sd	s0, 48(sp)
	sd	s1, 56(sp)
	sd	t1, 0(sp)
	sd	t2, 8(sp)
	sd	t3, 16(sp)
	sd	t4, 24(sp)
	mv	a0, t0
	call	kernel_dispatch_worker_0_0
	ld	ra, 88(sp)                      # 8-byte Folded Reload
	ld	s0, 80(sp)                      # 8-byte Folded Reload
	ld	s1, 72(sp)                      # 8-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	.cfi_restore s1
	addi	sp, sp, 96
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end2:
	.size	__dispatch_thread_entry_kernel_dispatch_worker_0_0, .Lfunc_end2-__dispatch_thread_entry_kernel_dispatch_worker_0_0
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
