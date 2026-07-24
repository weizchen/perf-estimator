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
	addi	sp, sp, -96
	.cfi_def_cfa_offset 96
	sd	ra, 88(sp)                      # 8-byte Folded Spill
	.cfi_offset ra, -8
	ld	t0, 112(sp)
	ld	t1, 104(sp)
	ld	t2, 96(sp)
	sd	a5, 0(sp)
	sd	a6, 8(sp)
	sd	a7, 16(sp)
	sd	t2, 24(sp)
	sd	t1, 32(sp)
	sd	t0, 40(sp)
	sd	a0, 48(sp)
	sd	a1, 56(sp)
	sd	a2, 64(sp)
	sd	a3, 72(sp)
	sd	a4, 80(sp)
	lui	a2, %hi(__dispatch_thread_entry_kernel_dispatch_worker_0_0)
	addi	a2, a2, %lo(__dispatch_thread_entry_kernel_dispatch_worker_0_0)
	mv	a3, sp
	li	a0, 0
	li	a1, 0
	call	ofa_dispatch_thread_create
	call	ofa_dispatch_thread_join
	ld	ra, 88(sp)                      # 8-byte Folded Reload
	.cfi_restore ra
	addi	sp, sp, 96
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
	li	a0, 0
	slli	a2, a2, 2
	add	a1, a1, a2
	lbu	a2, 3(a1)
	slli	a5, a5, 2
	add	a5, a5, a4
	sb	a2, 3(a5)
	lbu	a2, 2(a1)
	sb	a2, 2(a5)
	lbu	a2, 1(a1)
	sb	a2, 1(a5)
	lbu	a2, 0(a1)
	ld	a3, 0(sp)
	ld	a1, 16(sp)
	sb	a2, 0(a5)
	li	a2, 1023
	slli	a3, a3, 2
	add	a7, a7, a3
	bltz	a2, .LBB1_2
.LBB1_1:                                # =>This Inner Loop Header: Depth=1
	mul	a3, a0, a1
	flw	fa5, 0(a4)
	slli	a3, a3, 2
	add	a3, a3, a7
	flw	fa4, 0(a3)
	fadd.s	fa5, fa4, fa5
	fsw	fa5, 0(a4)
	addi	a0, a0, 1
	bge	a2, a0, .LBB1_1
.LBB1_2:
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
	addi	sp, sp, -32
	.cfi_def_cfa_offset 32
	sd	ra, 24(sp)                      # 8-byte Folded Spill
	.cfi_offset ra, -8
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
	ld	a0, 80(a0)
	sd	t1, 0(sp)
	sd	t2, 8(sp)
	sd	a0, 16(sp)
	mv	a0, t0
	call	kernel_dispatch_worker_0_0
	ld	ra, 24(sp)                      # 8-byte Folded Reload
	.cfi_restore ra
	addi	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end2:
	.size	__dispatch_thread_entry_kernel_dispatch_worker_0_0, .Lfunc_end2-__dispatch_thread_entry_kernel_dispatch_worker_0_0
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
