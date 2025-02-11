// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "BaseQuestManager.generated.h"

// Struct to represent an individual quest step
USTRUCT(BlueprintType)
struct FQuestStep {
    GENERATED_BODY()

    UPROPERTY(BlueprintReadWrite, Category = "Quest")
    FString Name; // Name of the quest step

    UPROPERTY(BlueprintReadWrite, Category = "Quest")
    FString Description; // Description of the quest step

    UPROPERTY(BlueprintReadWrite, Category = "Quest")
    bool bCompleted; // Whether the step is completed

    // Default constructor
    FQuestStep()
        : Name(TEXT("")), Description(TEXT("")), bCompleted(false) {}

    // Parameterized constructor
    FQuestStep(const FString& StepName, const FString& StepDescription)
        : Name(StepName), Description(StepDescription), bCompleted(false) {}
};

// Class to manage the quest system
UCLASS(Blueprintable, BlueprintType)
class TEMPORALGARDEN_API ABaseQuestManager : public AActor {
    GENERATED_BODY()

private:
    UPROPERTY()
    TArray<FQuestStep> Steps; // List of quest steps

    UPROPERTY()
    int32 CurrentStepIndex; // Index of the current quest step

public:
    // Constructor
    ABaseQuestManager();

    // Initialize the quest system with predefined steps
    UFUNCTION(BlueprintCallable, Category = "Quest")
    void InitializeQuestSystem();

    // Get the details of the current quest step
    UFUNCTION(BlueprintCallable, Category = "Quest")
    FQuestStep GetCurrentStep() const;

    // Mark the current step as completed and move to the next step
    UFUNCTION(BlueprintCallable, Category = "Quest")
    void CompleteCurrentStep();

    // Add a new step to the quest
    UFUNCTION(BlueprintCallable, Category = "Quest")
    void AddStep(const FString& StepName, const FString& StepDescription);

    // Complete a step by name
    UFUNCTION(BlueprintCallable, Category = "Quest")
    bool CompleteStepByName(const FString& StepName);

    // Get all quest steps
    UFUNCTION(BlueprintCallable, Category = "Quest")
    TArray<FQuestStep> GetAllSteps() const;

    // Blueprint event to be called when a step is completed
    UFUNCTION(BlueprintImplementableEvent, Category = "Quest")
    void OnStepCompleted(const FQuestStep& CompletedStep);
};