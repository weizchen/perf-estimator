; ModuleID = 'ofa_module'
source_filename = "ofa_module"

declare void @ofa_dispatch_thread_join(i64)

declare i64 @ofa_dispatch_thread_create(i64, i64, ptr, ptr)

define void @kernel(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, ptr %8, ptr %9, i64 %10) {
  %12 = insertvalue { ptr, ptr, i64 } poison, ptr %8, 0
  %13 = insertvalue { ptr, ptr, i64 } %12, ptr %9, 1
  %14 = insertvalue { ptr, ptr, i64 } %13, i64 %10, 2
  %15 = insertvalue { ptr, ptr, i64 } poison, ptr %5, 0
  %16 = insertvalue { ptr, ptr, i64 } %15, ptr %6, 1
  %17 = insertvalue { ptr, ptr, i64 } %16, i64 %7, 2
  %18 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %19 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %18, ptr %1, 1
  %20 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %19, i64 %2, 2
  %21 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, i64 %3, 3, 0
  %22 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, i64 %4, 4, 0
  %23 = alloca { { ptr, ptr, i64 }, { ptr, ptr, i64 }, { ptr, ptr, i64, [1 x i64], [1 x i64] } }, align 8
  %24 = getelementptr { { ptr, ptr, i64 }, { ptr, ptr, i64 }, { ptr, ptr, i64, [1 x i64], [1 x i64] } }, ptr %23, i32 0, i32 0
  store { ptr, ptr, i64 } %17, ptr %24, align 8
  %25 = getelementptr { { ptr, ptr, i64 }, { ptr, ptr, i64 }, { ptr, ptr, i64, [1 x i64], [1 x i64] } }, ptr %23, i32 0, i32 1
  store { ptr, ptr, i64 } %14, ptr %25, align 8
  %26 = getelementptr { { ptr, ptr, i64 }, { ptr, ptr, i64 }, { ptr, ptr, i64, [1 x i64], [1 x i64] } }, ptr %23, i32 0, i32 2
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %22, ptr %26, align 8
  %27 = call i64 @ofa_dispatch_thread_create(i64 0, i64 0, ptr @__dispatch_thread_entry_kernel_dispatch_worker_0_0, ptr %23)
  call void @ofa_dispatch_thread_join(i64 %27)
  ret void
}

define void @kernel_dispatch_worker_0_0(ptr %0, ptr %1, i64 %2, ptr %3, ptr %4, i64 %5, ptr %6, ptr %7, i64 %8, i64 %9, i64 %10) {
  %12 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %6, 0
  %13 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, ptr %7, 1
  %14 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, i64 %8, 2
  %15 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, i64 %9, 3, 0
  %16 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %15, i64 %10, 4, 0
  %17 = insertvalue { ptr, ptr, i64 } poison, ptr %3, 0
  %18 = insertvalue { ptr, ptr, i64 } %17, ptr %4, 1
  %19 = insertvalue { ptr, ptr, i64 } %18, i64 %5, 2
  %20 = insertvalue { ptr, ptr, i64 } poison, ptr %0, 0
  %21 = insertvalue { ptr, ptr, i64 } %20, ptr %1, 1
  %22 = insertvalue { ptr, ptr, i64 } %21, i64 %2, 2
  %23 = extractvalue { ptr, ptr, i64 } %22, 1
  %24 = extractvalue { ptr, ptr, i64 } %22, 2
  %25 = getelementptr float, ptr %23, i64 %24
  %26 = extractvalue { ptr, ptr, i64 } %19, 1
  %27 = extractvalue { ptr, ptr, i64 } %19, 2
  %28 = getelementptr float, ptr %26, i64 %27
  call void @llvm.memcpy.p0.p0.i64(ptr %28, ptr %25, i64 4, i1 false)
  br label %29

29:                                               ; preds = %32, %11
  %30 = phi i64 [ %44, %32 ], [ 0, %11 ]
  %31 = icmp slt i64 %30, 1024
  br i1 %31, label %32, label %45

32:                                               ; preds = %29
  %33 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 1
  %34 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 2
  %35 = getelementptr float, ptr %33, i64 %34
  %36 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 4, 0
  %37 = mul nuw nsw i64 %30, %36
  %38 = getelementptr inbounds nuw float, ptr %35, i64 %37
  %39 = load float, ptr %38, align 4
  %40 = extractvalue { ptr, ptr, i64 } %19, 1
  %41 = load float, ptr %40, align 4
  %42 = fadd float %39, %41
  %43 = extractvalue { ptr, ptr, i64 } %19, 1
  store float %42, ptr %43, align 4
  %44 = add i64 %30, 1
  br label %29

45:                                               ; preds = %29
  ret void
}

define void @__dispatch_thread_entry_kernel_dispatch_worker_0_0(ptr %0) {
  %2 = getelementptr { { ptr, ptr, i64 }, { ptr, ptr, i64 }, { ptr, ptr, i64, [1 x i64], [1 x i64] } }, ptr %0, i32 0, i32 0
  %3 = load { ptr, ptr, i64 }, ptr %2, align 8
  %4 = getelementptr { { ptr, ptr, i64 }, { ptr, ptr, i64 }, { ptr, ptr, i64, [1 x i64], [1 x i64] } }, ptr %0, i32 0, i32 1
  %5 = load { ptr, ptr, i64 }, ptr %4, align 8
  %6 = getelementptr { { ptr, ptr, i64 }, { ptr, ptr, i64 }, { ptr, ptr, i64, [1 x i64], [1 x i64] } }, ptr %0, i32 0, i32 2
  %7 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %6, align 8
  %8 = extractvalue { ptr, ptr, i64 } %3, 0
  %9 = extractvalue { ptr, ptr, i64 } %3, 1
  %10 = extractvalue { ptr, ptr, i64 } %3, 2
  %11 = extractvalue { ptr, ptr, i64 } %5, 0
  %12 = extractvalue { ptr, ptr, i64 } %5, 1
  %13 = extractvalue { ptr, ptr, i64 } %5, 2
  %14 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 0
  %15 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 1
  %16 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 2
  %17 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 3, 0
  %18 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 4, 0
  call void @kernel_dispatch_worker_0_0(ptr %8, ptr %9, i64 %10, ptr %11, ptr %12, i64 %13, ptr %14, ptr %15, i64 %16, i64 %17, i64 %18)
  ret void
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #0

attributes #0 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
