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
	addi	sp, sp, -336
	.cfi_def_cfa_offset 336
	sd	ra, 328(sp)                     # 8-byte Folded Spill
	sd	s0, 320(sp)                     # 8-byte Folded Spill
	sd	s1, 312(sp)                     # 8-byte Folded Spill
	sd	s2, 304(sp)                     # 8-byte Folded Spill
	sd	s3, 296(sp)                     # 8-byte Folded Spill
	sd	s4, 288(sp)                     # 8-byte Folded Spill
	sd	s5, 280(sp)                     # 8-byte Folded Spill
	sd	s6, 272(sp)                     # 8-byte Folded Spill
	sd	s7, 264(sp)                     # 8-byte Folded Spill
	sd	s8, 256(sp)                     # 8-byte Folded Spill
	sd	s9, 248(sp)                     # 8-byte Folded Spill
	sd	s10, 240(sp)                    # 8-byte Folded Spill
	sd	s11, 232(sp)                    # 8-byte Folded Spill
	.cfi_offset ra, -8
	.cfi_offset s0, -16
	.cfi_offset s1, -24
	.cfi_offset s2, -32
	.cfi_offset s3, -40
	.cfi_offset s4, -48
	.cfi_offset s5, -56
	.cfi_offset s6, -64
	.cfi_offset s7, -72
	.cfi_offset s8, -80
	.cfi_offset s9, -88
	.cfi_offset s10, -96
	.cfi_offset s11, -104
	ld	t0, 336(sp)
	ld	t1, 344(sp)
	ld	t2, 352(sp)
	ld	t3, 360(sp)
	ld	t4, 368(sp)
	ld	t5, 376(sp)
	ld	t6, 488(sp)
	ld	s2, 480(sp)
	ld	s3, 472(sp)
	ld	s4, 464(sp)
	ld	s5, 456(sp)
	ld	s6, 448(sp)
	ld	s7, 440(sp)
	ld	s0, 384(sp)
	ld	s1, 392(sp)
	ld	s8, 400(sp)
	ld	s9, 408(sp)
	ld	s10, 416(sp)
	ld	s11, 424(sp)
	ld	ra, 432(sp)
	sd	a2, 136(sp)
	sd	a3, 144(sp)
	sd	a4, 152(sp)
	sd	a5, 160(sp)
	sd	s0, 8(sp)
	sd	s1, 16(sp)
	sd	s8, 24(sp)
	sd	s9, 32(sp)
	sd	s10, 40(sp)
	sd	s11, 48(sp)
	sd	ra, 56(sp)
	sd	s7, 64(sp)
	sd	s6, 72(sp)
	sd	s5, 80(sp)
	sd	s4, 88(sp)
	sd	s3, 96(sp)
	sd	s2, 104(sp)
	sd	t6, 112(sp)
	sd	a0, 120(sp)
	sd	a1, 128(sp)
	sd	t2, 200(sp)
	sd	t3, 208(sp)
	sd	t4, 216(sp)
	sd	t5, 224(sp)
	sd	a6, 168(sp)
	sd	a7, 176(sp)
	sd	t0, 184(sp)
	sd	t1, 192(sp)
	lui	a2, %hi(__dispatch_thread_entry_kernel_dispatch_worker_0_0)
	addi	a2, a2, %lo(__dispatch_thread_entry_kernel_dispatch_worker_0_0)
	addi	a3, sp, 8
	li	a0, 0
	li	a1, 0
	call	ofa_dispatch_thread_create
	call	ofa_dispatch_thread_join
	ld	ra, 328(sp)                     # 8-byte Folded Reload
	ld	s0, 320(sp)                     # 8-byte Folded Reload
	ld	s1, 312(sp)                     # 8-byte Folded Reload
	ld	s2, 304(sp)                     # 8-byte Folded Reload
	ld	s3, 296(sp)                     # 8-byte Folded Reload
	ld	s4, 288(sp)                     # 8-byte Folded Reload
	ld	s5, 280(sp)                     # 8-byte Folded Reload
	ld	s6, 272(sp)                     # 8-byte Folded Reload
	ld	s7, 264(sp)                     # 8-byte Folded Reload
	ld	s8, 256(sp)                     # 8-byte Folded Reload
	ld	s9, 248(sp)                     # 8-byte Folded Reload
	ld	s10, 240(sp)                    # 8-byte Folded Reload
	ld	s11, 232(sp)                    # 8-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	.cfi_restore s1
	.cfi_restore s2
	.cfi_restore s3
	.cfi_restore s4
	.cfi_restore s5
	.cfi_restore s6
	.cfi_restore s7
	.cfi_restore s8
	.cfi_restore s9
	.cfi_restore s10
	.cfi_restore s11
	addi	sp, sp, 336
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
	addi	sp, sp, -272
	.cfi_def_cfa_offset 272
	sd	ra, 264(sp)                     # 8-byte Folded Spill
	sd	s0, 256(sp)                     # 8-byte Folded Spill
	sd	s1, 248(sp)                     # 8-byte Folded Spill
	sd	s2, 240(sp)                     # 8-byte Folded Spill
	sd	s3, 232(sp)                     # 8-byte Folded Spill
	sd	s4, 224(sp)                     # 8-byte Folded Spill
	.cfi_offset ra, -8
	.cfi_offset s0, -16
	.cfi_offset s1, -24
	.cfi_offset s2, -32
	.cfi_offset s3, -40
	.cfi_offset s4, -48
	mv	s0, sp
	ld	s2, 384(sp)
	ld	s4, 328(sp)
	ld	s3, 272(sp)
	ld	t1, 280(sp)
	ld	t0, 288(sp)
	ld	s1, 296(sp)
	ld	t2, 304(sp)
	ld	t3, 312(sp)
	sd	a0, 168(sp)
	sd	a1, 176(sp)
	sd	a2, 184(sp)
	sd	a3, 192(sp)
	sd	a4, 200(sp)
	sd	a5, 208(sp)
	sd	a6, 216(sp)
	li	a0, 2
	addi	a1, sp, 168
	addi	a2, sp, 112
	sd	a0, 96(sp)
	sd	a1, 104(sp)
	sd	s1, 144(sp)
	sd	t2, 152(sp)
	sd	t3, 160(sp)
	sd	a7, 112(sp)
	sd	s3, 120(sp)
	sd	t1, 128(sp)
	sd	t0, 136(sp)
	sd	a0, 80(sp)
	sd	a2, 88(sp)
	li	a0, 4
	addi	a1, sp, 96
	addi	a2, sp, 80
	call	memrefCopy
	mv	sp, s0
	lui	a0, 64
	call	_mlir_memref_to_llvm_alloc
	mv	s0, a0
	lui	a2, 64
	mv	a0, s4
	mv	a1, s0
	call	float32tofloat8
	lui	a0, 256
	call	_mlir_memref_to_llvm_alloc
	mv	s1, a0
	lui	a2, 256
	mv	a0, s2
	mv	a1, s1
	call	float32tofloat8
	li	a0, 1
	li	a1, 256
	li	a6, 64
	lui	a7, 1
	li	a2, 64
	lui	a3, 1
	lui	a4, 1
	li	a5, 1
	sd	a1, 64(sp)
	sd	a0, 72(sp)
	sd	s3, 32(sp)
	sd	zero, 40(sp)
	sd	a6, 48(sp)
	sd	a1, 56(sp)
	sd	a7, 0(sp)
	sd	a1, 8(sp)
	sd	a1, 16(sp)
	sd	a0, 24(sp)
	mv	a0, s0
	li	a1, 0
	mv	a6, s1
	li	a7, 0
	call	dispatch_kernel_matmul_me_f8_2d
	ld	ra, 264(sp)                     # 8-byte Folded Reload
	ld	s0, 256(sp)                     # 8-byte Folded Reload
	ld	s1, 248(sp)                     # 8-byte Folded Reload
	ld	s2, 240(sp)                     # 8-byte Folded Reload
	ld	s3, 232(sp)                     # 8-byte Folded Reload
	ld	s4, 224(sp)                     # 8-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	.cfi_restore s1
	.cfi_restore s2
	.cfi_restore s3
	.cfi_restore s4
	addi	sp, sp, 272
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
	addi	sp, sp, -272
	.cfi_def_cfa_offset 272
	sd	ra, 264(sp)                     # 8-byte Folded Spill
	sd	s0, 256(sp)                     # 8-byte Folded Spill
	sd	s1, 248(sp)                     # 8-byte Folded Spill
	sd	s2, 240(sp)                     # 8-byte Folded Spill
	sd	s3, 232(sp)                     # 8-byte Folded Spill
	sd	s4, 224(sp)                     # 8-byte Folded Spill
	sd	s5, 216(sp)                     # 8-byte Folded Spill
	sd	s6, 208(sp)                     # 8-byte Folded Spill
	sd	s7, 200(sp)                     # 8-byte Folded Spill
	sd	s8, 192(sp)                     # 8-byte Folded Spill
	sd	s9, 184(sp)                     # 8-byte Folded Spill
	sd	s10, 176(sp)                    # 8-byte Folded Spill
	sd	s11, 168(sp)                    # 8-byte Folded Spill
	.cfi_offset ra, -8
	.cfi_offset s0, -16
	.cfi_offset s1, -24
	.cfi_offset s2, -32
	.cfi_offset s3, -40
	.cfi_offset s4, -48
	.cfi_offset s5, -56
	.cfi_offset s6, -64
	.cfi_offset s7, -72
	.cfi_offset s8, -80
	.cfi_offset s9, -88
	.cfi_offset s10, -96
	.cfi_offset s11, -104
	mv	t0, a0
	ld	a0, 0(a0)
	ld	a1, 8(t0)
	ld	a2, 16(t0)
	ld	a3, 24(t0)
	ld	a4, 32(t0)
	ld	a5, 40(t0)
	ld	a6, 48(t0)
	ld	a7, 56(t0)
	ld	t1, 64(t0)
	ld	t2, 72(t0)
	ld	t3, 80(t0)
	ld	t4, 88(t0)
	ld	t5, 96(t0)
	ld	t6, 104(t0)
	ld	s2, 112(t0)
	ld	s3, 120(t0)
	ld	s6, 128(t0)
	ld	s7, 136(t0)
	ld	s4, 144(t0)
	ld	s5, 152(t0)
	ld	s10, 160(t0)
	ld	s11, 168(t0)
	ld	s8, 176(t0)
	ld	s9, 184(t0)
	ld	s0, 192(t0)
	ld	s1, 200(t0)
	ld	ra, 208(t0)
	ld	t0, 216(t0)
	sd	s0, 128(sp)
	sd	s1, 136(sp)
	sd	ra, 144(sp)
	sd	t0, 152(sp)
	sd	s10, 96(sp)
	sd	s11, 104(sp)
	sd	s8, 112(sp)
	sd	s9, 120(sp)
	sd	s6, 64(sp)
	sd	s7, 72(sp)
	sd	s4, 80(sp)
	sd	s5, 88(sp)
	sd	t5, 32(sp)
	sd	t6, 40(sp)
	sd	s2, 48(sp)
	sd	s3, 56(sp)
	sd	t1, 0(sp)
	sd	t2, 8(sp)
	sd	t3, 16(sp)
	sd	t4, 24(sp)
	call	kernel_dispatch_worker_0_0
	ld	ra, 264(sp)                     # 8-byte Folded Reload
	ld	s0, 256(sp)                     # 8-byte Folded Reload
	ld	s1, 248(sp)                     # 8-byte Folded Reload
	ld	s2, 240(sp)                     # 8-byte Folded Reload
	ld	s3, 232(sp)                     # 8-byte Folded Reload
	ld	s4, 224(sp)                     # 8-byte Folded Reload
	ld	s5, 216(sp)                     # 8-byte Folded Reload
	ld	s6, 208(sp)                     # 8-byte Folded Reload
	ld	s7, 200(sp)                     # 8-byte Folded Reload
	ld	s8, 192(sp)                     # 8-byte Folded Reload
	ld	s9, 184(sp)                     # 8-byte Folded Reload
	ld	s10, 176(sp)                    # 8-byte Folded Reload
	ld	s11, 168(sp)                    # 8-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	.cfi_restore s1
	.cfi_restore s2
	.cfi_restore s3
	.cfi_restore s4
	.cfi_restore s5
	.cfi_restore s6
	.cfi_restore s7
	.cfi_restore s8
	.cfi_restore s9
	.cfi_restore s10
	.cfi_restore s11
	addi	sp, sp, 272
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end2:
	.size	__dispatch_thread_entry_kernel_dispatch_worker_0_0, .Lfunc_end2-__dispatch_thread_entry_kernel_dispatch_worker_0_0
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
