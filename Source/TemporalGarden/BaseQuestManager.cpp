// Fill out your copyright notice in the Description page of Project Settings.

#include "BaseQuestManager.h"
#include "Kismet/KismetSystemLibrary.h"

// Constructor
ABaseQuestManager::ABaseQuestManager() {
    PrimaryActorTick.bCanEverTick = false;
    CurrentStepIndex = 0;
}

// Initialize the quest system
void ABaseQuestManager::InitializeQuestSystem() {
    Steps = {
        FQuestStep(TEXT("Collect Gold"), TEXT("Gather enough gold to begin your journey.")),
        FQuestStep(TEXT("Buy Pot"), TEXT("Purchase a pot from the merchant.")),
        FQuestStep(TEXT("Place Pot"), TEXT("Place the pot in the designated area.")),
    };
    CurrentStepIndex = 0;
    UKismetSystemLibrary::PrintString(this, TEXT("Quest steps initialized."), true, true, FColor::Green, 5.0f);
}

// Get the details of the current quest step
FQuestStep ABaseQuestManager::GetCurrentStep() const {
    if (Steps.IsValidIndex(CurrentStepIndex)) {
        return Steps[CurrentStepIndex];
    }
    return FQuestStep();
}

// Mark the current step as completed and move to the next step
void ABaseQuestManager::CompleteCurrentStep() {
    if (Steps.IsValidIndex(CurrentStepIndex)) {

        FQuestStep& CompletedStep = Steps[CurrentStepIndex];
        Steps[CurrentStepIndex].bCompleted = true;

        // Call the Blueprint event
        OnStepCompleted(CompletedStep);

        UKismetSystemLibrary::PrintString(this, FString::Printf(TEXT("Step completed: %s"), *Steps[CurrentStepIndex].Name), true, true, FColor::Yellow, 5.0f);

        if (++CurrentStepIndex >= Steps.Num()) {
            UKismetSystemLibrary::PrintString(this, TEXT("All steps completed!"), true, true, FColor::Blue, 5.0f);
        }
    }
}

// Add a new step to the quest
void ABaseQuestManager::AddStep(const FString& StepName, const FString& StepDescription) {
    Steps.Add(FQuestStep(StepName, StepDescription));
    UKismetSystemLibrary::PrintString(this, FString::Printf(TEXT("Step added: %s"), *StepName), true, true, FColor::Green, 5.0f);
}

// Complete a step by name
bool ABaseQuestManager::CompleteStepByName(const FString& StepName) {
    for (FQuestStep& Step : Steps) {
        if (Step.Name == StepName) {
            if (!Step.bCompleted) {

                Step.bCompleted = true;

                // Call the Blueprint event
                OnStepCompleted(Step);

                UKismetSystemLibrary::PrintString(this, FString::Printf(TEXT("Step completed: %s"), *StepName), true, true, FColor::Yellow, 5.0f);
                return true;
            }
            else {
                UKismetSystemLibrary::PrintString(this, FString::Printf(TEXT("Step already completed: %s"), *StepName), true, true, FColor::Orange, 5.0f);
                return false;
            }
        }
    }
    UKismetSystemLibrary::PrintString(this, FString::Printf(TEXT("Step not found: %s"), *StepName), true, true, FColor::Red, 5.0f);
    return false;
}

// Get all quest steps
TArray<FQuestStep> ABaseQuestManager::GetAllSteps() const {
    return Steps;
}