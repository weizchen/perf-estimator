; ModuleID = 'ofa_module'
source_filename = "ofa_module"

declare void @memrefCopy(i64, ptr, ptr)

declare void @ofa_dispatch_thread_join(i64)

declare i64 @ofa_dispatch_thread_create(i64, i64, ptr, ptr)

define void @kernel(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, ptr %7, ptr %8, i64 %9, i64 %10, i64 %11, ptr %12, ptr %13, i64 %14, i64 %15, i64 %16) {
  %18 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %12, 0
  %19 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %18, ptr %13, 1
  %20 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %19, i64 %14, 2
  %21 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, i64 %15, 3, 0
  %22 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, i64 %16, 4, 0
  %23 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %7, 0
  %24 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %23, ptr %8, 1
  %25 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %24, i64 %9, 2
  %26 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %25, i64 %10, 3, 0
  %27 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %26, i64 %11, 4, 0
  %28 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %0, 0
  %29 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %28, ptr %1, 1
  %30 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, i64 %2, 2
  %31 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %30, i64 %3, 3, 0
  %32 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %31, i64 %5, 4, 0
  %33 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, i64 %4, 3, 1
  %34 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %33, i64 %6, 4, 1
  %35 = alloca { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, align 8
  %36 = getelementptr { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, ptr %35, i32 0, i32 0
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, ptr %36, align 8
  %37 = getelementptr { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, ptr %35, i32 0, i32 1
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %22, ptr %37, align 8
  %38 = getelementptr { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, ptr %35, i32 0, i32 2
  store { ptr, ptr, i64, [2 x i64], [2 x i64] } %34, ptr %38, align 8
  %39 = call i64 @ofa_dispatch_thread_create(i64 0, i64 0, ptr @__dispatch_thread_entry_kernel_dispatch_worker_0_0, ptr %35)
  call void @ofa_dispatch_thread_join(i64 %39)
  ret void
}

define void @kernel_dispatch_worker_0_0(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, ptr %10, ptr %11, i64 %12, i64 %13, i64 %14, i64 %15, i64 %16) {
  %18 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %10, 0
  %19 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %18, ptr %11, 1
  %20 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %19, i64 %12, 2
  %21 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %20, i64 %13, 3, 0
  %22 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %21, i64 %15, 4, 0
  %23 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, i64 %14, 3, 1
  %24 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %23, i64 %16, 4, 1
  %25 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %5, 0
  %26 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %25, ptr %6, 1
  %27 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %26, i64 %7, 2
  %28 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, i64 %8, 3, 0
  %29 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, i64 %9, 4, 0
  %30 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %31 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %30, ptr %1, 1
  %32 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %31, i64 %2, 2
  %33 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %32, i64 %3, 3, 0
  %34 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %33, i64 %4, 4, 0
  %35 = call ptr @llvm.stacksave.p0()
  %36 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %34, ptr %36, align 8
  %37 = insertvalue { i64, ptr } { i64 1, ptr poison }, ptr %36, 1
  %38 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %29, ptr %38, align 8
  %39 = insertvalue { i64, ptr } { i64 1, ptr poison }, ptr %38, 1
  %40 = alloca { i64, ptr }, i64 1, align 8
  store { i64, ptr } %37, ptr %40, align 8
  %41 = alloca { i64, ptr }, i64 1, align 8
  store { i64, ptr } %39, ptr %41, align 8
  call void @memrefCopy(i64 4, ptr %40, ptr %41)
  call void @llvm.stackrestore.p0(ptr %35)
  br label %42

42:                                               ; preds = %66, %17
  %43 = phi i64 [ %67, %66 ], [ 0, %17 ]
  %44 = icmp slt i64 %43, 256
  br i1 %44, label %45, label %68

45:                                               ; preds = %48, %42
  %46 = phi i64 [ %65, %48 ], [ 0, %42 ]
  %47 = icmp slt i64 %46, 512
  br i1 %47, label %48, label %66

48:                                               ; preds = %45
  %49 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %50 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 2
  %51 = getelementptr float, ptr %49, i64 %50
  %52 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 4, 0
  %53 = mul nuw nsw i64 %43, %52
  %54 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 4, 1
  %55 = mul nuw nsw i64 %46, %54
  %56 = add nuw nsw i64 %53, %55
  %57 = getelementptr inbounds nuw float, ptr %51, i64 %56
  %58 = load float, ptr %57, align 4
  %59 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %29, 1
  %60 = getelementptr inbounds nuw float, ptr %59, i64 %43
  %61 = load float, ptr %60, align 4
  %62 = fadd float %58, %61
  %63 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %29, 1
  %64 = getelementptr inbounds nuw float, ptr %63, i64 %43
  store float %62, ptr %64, align 4
  %65 = add i64 %46, 1
  br label %45

66:                                               ; preds = %45
  %67 = add i64 %43, 1
  br label %42

68:                                               ; preds = %42
  ret void
}

define void @__dispatch_thread_entry_kernel_dispatch_worker_0_0(ptr %0) {
  %2 = getelementptr { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, ptr %0, i32 0, i32 0
  %3 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %2, align 8
  %4 = getelementptr { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, ptr %0, i32 0, i32 1
  %5 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %4, align 8
  %6 = getelementptr { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, ptr %0, i32 0, i32 2
  %7 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %6, align 8
  %8 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 0
  %9 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 1
  %10 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 2
  %11 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 3, 0
  %12 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 4, 0
  %13 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %5, 0
  %14 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %5, 1
  %15 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %5, 2
  %16 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %5, 3, 0
  %17 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %5, 4, 0
  %18 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, 0
  %19 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, 1
  %20 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, 2
  %21 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, 3, 0
  %22 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, 3, 1
  %23 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, 4, 0
  %24 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, 4, 1
  call void @kernel_dispatch_worker_0_0(ptr %8, ptr %9, i64 %10, i64 %11, i64 %12, ptr %13, ptr %14, i64 %15, i64 %16, i64 %17, ptr %18, ptr %19, i64 %20, i64 %21, i64 %22, i64 %23, i64 %24)
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare ptr @llvm.stacksave.p0() #0

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.stackrestore.p0(ptr) #0

attributes #0 = { nocallback nofree nosync nounwind willreturn }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
